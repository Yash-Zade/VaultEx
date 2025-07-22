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

    // function desposit(address _address, uint256 _amount) public onlyOwner{

    // }

    // function withdraw(address _address, uint256 _amount) public onlyOwner{

    // }

    function buy(uint256 _collateral, uint256 _size) public returns(uint256){

        uint256 newQuoteReserve = _size;
        uint256 newBaseReserve = k/quoteReserve;

        quoteReserve = newQuoteReserve;
        baseReserve = newBaseReserve;

        lastPrice = getVirtualAMMPrice();

        uint mintableTokens = getMintablevETH(_collateral);

        return mintableTokens;

    }

    function sell(address _user,uint256 _collateral, uint256 _size, uint256 _entryPrice, uint8 _leverage) public returns(uint256){
        
    }
    function getVirtualAMMPrice() public view returns (uint256) {
        require(baseReserve > 0, "Invalid reserve");
        return (quoteReserve * 1e18) / baseReserve;
    }

    function getMintablevETH(uint256 usdtAmount) internal view returns (uint256) {
        uint256 ethPrice = getVirtualAMMPrice();
        require(ethPrice > 0, "Invalid price");

        return (usdtAmount * 1e18) / uint256(ethPrice);
    }

}