// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GasContract {
    uint256 public immutable totalSupply; // cannot be updated
    mapping(address => uint256) public balanceOf;
    mapping(address => Payment[]) private payments;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;
    bool private called = false;

    struct Payment {
        uint256 paymentType;
        uint256 amount;
    }

    struct ImportantStruct {
        uint8 valueA; // max 3 digits
        uint64 bigValue;
        uint8 valueB; // max 3 digits
    }

    event Transfer(address recipient, uint256 amount);

    constructor(address[5] memory _admins, uint256 _totalSupply) {
        balanceOf[msg.sender] = totalSupply = _totalSupply;
        administrators = _admins;
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
        balanceOf[msg.sender] -= _amount;
        balanceOf[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.amount = _amount;
        payments[msg.sender].push(payment);
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        uint8 _type
    ) public {
        require(!called);
        called = true;
        payments[_user][0].paymentType = _type;
        payments[_user][0].amount = _amount;
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) public {
        whitelist[_userAddrs] = _tier;
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct calldata _struct
    ) public {
        uint256 check = _amount - whitelist[msg.sender];
        balanceOf[msg.sender] -= check;
        balanceOf[_recipient] += check;
    }
}
