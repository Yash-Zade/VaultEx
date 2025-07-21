// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault{

    IERC20 public usdt;
    mapping(address => uint256) public balances;

    constructor(IERC20 _usdtAddress){
        usdt = _usdtAddress;
    }

    event Deposited(address indexed depositor, uint amount);
    event Withdrawn(address indexed withdrawer, uint amount);

    function deposit(uint256 _amount) public {
        require(_amount > 0, "Amount should be greater than 0");
        require(usdt.allowance(msg.sender, address(this)) >= _amount, "Insufficient allowance");
        require(usdt.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        balances[msg.sender] += _amount;
        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public {
        require(_amount > 0, "Amount should be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balances");
        balances[msg.sender] -= _amount;
        require(usdt.transfer(msg.sender, _amount), "Transfer failed");
        emit Withdrawn(msg.sender, _amount);
    }

    function getBalance() public view returns(uint256){
        return(balances[msg.sender]);
    }

    function getBalanceOf(address _user) public view returns(uint256){
        return(balances[_user]);
    }

    fallback() external payable{
        revert("Invalid Call");
    }

    receive() external payable{
        revert("ETH not accepted");
    }
}
