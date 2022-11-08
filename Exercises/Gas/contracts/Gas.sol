// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {
    address private owner;
    uint256 public immutable totalSupply; // cannot be updated
    mapping(address => uint256) private balances;
    mapping(address => Payment[]) private payments;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;

    struct Payment {
        uint256 paymentType;
        uint256 amount;
    }

    struct ImportantStruct {
        uint8 valueA; // max 3 digits
        uint64 bigValue;
        uint8 valueB; // max 3 digits
    }

    modifier checkIfWhiteListed(address sender) {
        require(
            msg.sender == sender //, "Gas.CheckIfWhiteListed: transaction originator is not sender"
        );
        uint256 usersTier = whitelist[msg.sender];
        require(usersTier > 0 && usersTier < 4);
        _;
    }

    event Transfer(address recipient, uint256 amount);

    constructor(address[5] memory _admins, uint256 _totalSupply) {
        owner = msg.sender;
        totalSupply = _totalSupply;

        for (uint256 ii = 0; ii < 5; ii++) {
            if (_admins[ii] != address(0)) {
                administrators[ii] = _admins[ii];
                if (_admins[ii] == msg.sender) {
                    balances[msg.sender] = _totalSupply;
                }
            }
        }
    }

    function balanceOf(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function getTradingMode() public pure returns (bool) {
        return true;
    }

    function getPayments(address _user) public view returns (Payment[] memory) {
        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.paymentType = 3;
        payment.amount = _amount;
        payments[msg.sender].push(payment);
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        uint8 _type
    ) public {
        require(owner == msg.sender);
        payments[_user][0].paymentType = _type;
        payments[_user][0].amount = _amount;
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) public {
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
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        balances[msg.sender] += whitelist[msg.sender];
        balances[_recipient] -= whitelist[msg.sender];
    }
}
