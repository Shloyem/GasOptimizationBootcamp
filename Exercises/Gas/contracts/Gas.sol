// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "./Ownable.sol";

contract GasContract is Ownable {
    uint256 public totalSupply; // cannot be updated
    uint256 private paymentCounter;
    mapping(address => uint256) private balances;
    uint256 private tradePercent = 12;
    mapping(address => Payment[]) private payments;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;
    enum PaymentType {
        BasicPayment,
        Unknown,
        Refund,
        Dividend,
        GroupPayment
    }

    struct Payment {
        PaymentType paymentType;
        uint256 paymentID;
        string recipientName; // max 8 characters
        address recipient;
        address admin; // administrators address
        uint256 amount;
    }

    struct ImportantStruct {
        uint8 valueA; // max 3 digits
        uint64 bigValue;
        uint8 valueB; // max 3 digits
    }

    /*modifier onlyAdminOrOwner() {
        if ((msg.sender == owner()) || checkForAdmin(msg.sender)) {
            // todo look for better owner check
            _;
        } else {
            revert();
            // "Gas:onlyAdminOrOwner"
        }
    }*/

    modifier checkIfWhiteListed(address sender) {
        require(
            msg.sender == sender //, "Gas.CheckIfWhiteListed: transaction originator is not sender"
        );
        uint256 usersTier = whitelist[msg.sender];
        require(usersTier > 0 && usersTier < 4);
        /*require(
            usersTier > 0 //, "Gas:user is not whitelisted"
        );
        require(
            usersTier < 4 //, "Gas:incorrect tier is incorrect"
        );*/
        _;
    }

    event Transfer(address recipient, uint256 amount);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        totalSupply = _totalSupply;

        for (uint256 ii = 0; ii < 5; ii++) {
            if (_admins[ii] != address(0)) {
                administrators[ii] = _admins[ii];
                if (_admins[ii] == owner()) {
                    balances[owner()] = _totalSupply;
                }
            }
        }
    }

    /*function checkForAdmin(address _user) public view returns (bool) {
        for (uint256 ii = 0; ii < 5; ii++) {
            if (administrators[ii] == _user) {
                return true;
            }
        }
        return false;
    }*/

    function balanceOf(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function getTradingMode() public pure returns (bool) {
        return true;
    }

    function getPayments(address _user) public view returns (Payment[] memory) {
        // require(
        //     _user != address(0) //, "Gas:Invalid zero address"
        // );
        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public {
        require(balances[msg.sender] >= _amount && bytes(_name).length < 9);
        // require(
        //     balances[msg.sender] >= _amount //, "Gas:insufficient sender Balance"
        // );
        // require(
        //     bytes(_name).length < 9 //, "Gas:recipient name too long"
        // );
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.admin;
        payment.paymentType;
        payment.recipient = _recipient;
        payment.amount = _amount;
        payment.recipientName = _name;
        payment.paymentID = ++paymentCounter;
        payments[msg.sender].push(payment);
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) public onlyOwner //onlyAdminOrOwner
    {
        require(
            _ID > 0 && _amount > 0 && _user != address(0) //,"Gas:Invalid input"
        );
        // require(
        //     _ID > 0 //, "Gas Contract - Update Payment function - ID must be greater than 0"
        // );
        // require(
        //     _amount > 0 //, "Gas Contract - Update Payment function - Amount must be greater than 0"
        // );
        // require(
        //     _user != address(0) // , "Gas Contract - Update Payment function - Administrator must have a valid non zero address"
        // );

        for (uint256 ii = 0; ii < payments[_user].length; ii++) {
            if (payments[_user][ii].paymentID == _ID) {
                //payments[_user][ii].admin = _user;
                payments[_user][ii].paymentType = _type;
                payments[_user][ii].amount = _amount;
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
    /*onlyAdminOrOwner*/
    {
        /*require(
            _tier < 255 //, "Gas.addToWhitelist-tier lvl over 255"
        );*/
        // whitelist[_userAddrs] = _tier;
        if (_tier >= 3) {
            whitelist[_userAddrs] = 3;
        } else if (_tier == 1) {
            whitelist[_userAddrs] = 1;
        } else if (_tier == 2) {
            whitelist[_userAddrs] = 2;
        }
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory _struct
    ) public checkIfWhiteListed(msg.sender) {
        /* require(balances[msg.sender] >= _amount && _amount > 3); */

        // require(
        //     balances[msg.sender] >= _amount //, "Gas.whiteTransfers:Insufficient Sender Balance"
        // );
        // require(
        //     _amount > 3 //, "Gas.whiteTransfers:Amount not greater than 3"
        // );

        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        balances[msg.sender] += whitelist[msg.sender];
        balances[_recipient] -= whitelist[msg.sender];
    }
}
