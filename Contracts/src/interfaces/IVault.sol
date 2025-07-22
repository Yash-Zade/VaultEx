// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVault{
    function deposit(uint256 _amount) external; 
    function withdraw(uint256 _amount) external;
    function getBalance() external view returns(uint256);
    function getBalanceOf(address _user) external view returns(uint256);
    function lockBalance(address _user, uint256 _amount) external returns(bool);
    function unlockBalance(address _user, uint256 _amount) external returns(bool);
}