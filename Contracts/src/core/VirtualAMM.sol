// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IPriceFeed.sol";

contract VirtualAMM{

    address public owner;
    uint256 public baseReserve;
    uint256 public quoteReserve;
    uint256 public lastPrice;
    uint256 public k;
    IPriceFeed public priceFeed;

    constructor(uint256 _baseReserve, uint256 _quoteReserve, address _priceFeedAddress) {
        owner = msg.sender;
        baseReserve = _baseReserve;
        quoteReserve = _quoteReserve;
        priceFeed = IPriceFeed(_priceFeedAddress);
        k = baseReserve * quoteReserve;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function buy(uint256 _collateral, uint256 _size) public returns(uint256){

        uint256 newQuoteReserve = quoteReserve + _size;
        uint256 newBaseReserve = k/newQuoteReserve;

        quoteReserve = newQuoteReserve;
        baseReserve = newBaseReserve;

        lastPrice = getVirtualAMMPrice();

        uint mintableTokens = getMintableToken(_collateral);

        return mintableTokens;
    }

    function sell(uint256 _collateral) public returns(uint256){

        uint256 baseIn = getMintableToken(_collateral);
        uint256 newBaseReserve = baseReserve + baseIn;

        uint newQuoteReserve = k/newBaseReserve;

        uint256 vUSDTAmount = quoteReserve - newQuoteReserve;

        quoteReserve = newQuoteReserve;
        baseReserve = newBaseReserve;

        lastPrice = getVirtualAMMPrice();

        return vUSDTAmount;
    }


    function getVirtualAMMPrice() public view returns (uint256) {
        require(baseReserve > 0, "Invalid reserve");
        return (quoteReserve * 1e18) / baseReserve;
    }

    function getMintableToken(uint256 usdtAmount) internal view returns (uint256) {
        uint256 ethPrice = getVirtualAMMPrice();
        require(ethPrice > 0, "Invalid price");

        return (usdtAmount * 1e18) / (ethPrice);
    }

}