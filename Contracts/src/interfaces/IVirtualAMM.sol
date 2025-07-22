// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVirtualAMM{
    function desposit(address _address, uint256 _amount) external;

    function withdraw(address _address, uint256 _amount) external;

    function buy(uint256 _collateral, uint256 _size) external returns(uint256);

    function sell(uint256 _collateral) external returns(uint256);

    function getVirtualAMMPrice() external returns(uint256);
}