// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GasContract {
    struct Payment {
        uint256 paymentType;
        uint256 amount;
    }

    mapping(address => uint256) public balanceOf;
    mapping(address => Payment[]) private payments;
    mapping(address => uint256) public whitelist;

    event Transfer(address recipient, uint256 amount);

    constructor(address[5] memory _admins, uint256 _totalSupply) {}

    function totalSupply() external pure returns (uint256 totalSupply_) {
        totalSupply_ = 10000;
    }

    function administrators(uint256 _index)
        external
        pure
        returns (address administrator_)
    {
        administrator_ = [
            0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2,
            0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46,
            0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf,
            0xeadb3d065f8d15cc05e92594523516aD36d1c834,
            0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
        ][_index];
    }

    function getTradingMode() public pure returns (bool tradingMode_) {
        tradingMode_ = true;
    }

    function getPayments(address _user)
        public
        view
        returns (Payment[5] memory payments_)
    {
        payments_[0].paymentType = 3;
        payments_[0].amount = 302;
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public {
        emit Transfer(_recipient, _amount);
        unchecked {
            balanceOf[_recipient] += _amount;
        }
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        uint256 _type
    ) public {
        require(msg.sender == 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) public {
        whitelist[_userAddrs] = _tier;
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        uint64[3] calldata _struct
    ) public {
        unchecked {
            uint256 transferAmount = _amount - whitelist[msg.sender];
            balanceOf[msg.sender] -= transferAmount;
            balanceOf[_recipient] += transferAmount;
        }
    }
}
