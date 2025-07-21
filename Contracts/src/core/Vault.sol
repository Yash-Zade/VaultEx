// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault{

    IERC20 public usdt;
    address positionManager;
    address owner;
    mapping(address => uint256) balances;

    constructor(address _usdtAddress, address _owner){
        usdt = IERC20(_usdtAddress);
        owner = _owner;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner!");
        _;
    } 

    modifier onlyPositionManager(){
        require(msg.sender == positionManager, "You are not the Perpetual Manager!");
        _;
    } 

    event Deposited(address indexed depositor, uint amount);
    event Withdrawn(address indexed withdrawer, uint amount);
    event Credited(address indexed reciver, uint amount);

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

    function credit(address _user, uint256 _amount) external onlyPositionManager{
        balances[_user] += _amount;
        emit Credited(_user, _amount);
    }

    function getBalance() public view returns(uint256){
        return(balances[msg.sender]);
    }

    function getBalanceOf(address _user) public view returns(uint256){
        return(balances[_user]);
    }

    function setPositionManager(address _address) external onlyOwner(){
        positionManager = _address;
    }

    fallback() external payable{
        revert("Invalid Call");
    }

    receive() external payable{
        revert("ETH not accepted");
    }
}
