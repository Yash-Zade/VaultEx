// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IPriceFeed.sol";
import "../interfaces/IVault.sol";
import "../interfaces/IVirtualAMM.sol";

contract PositionManager {
    IPriceFeed priceFeed;
    IVault vault;
    IVirtualAMM amm;

    struct Position {
        address user;
        uint256 collateral;
        uint256 size;
        uint256 entryPrice;
        uint8 leverage;
        bool isLong;
        bool isOpen;
    }

    mapping(address => Position) positions;

    event OpenPosition(address indexed user, uint256 collateral, uint entryPrice, uint8 leverage, uint256 size, bool isLong);
    event ClosePosition(address indexed user, uint256 entryPrice, uint256 exitPrice, int256 pnl, bool isLong);

    constructor(address _vaultAddress, address _priceFeedAddress, address _ammAddress) {
        vault = IVault(_vaultAddress);
        priceFeed = IPriceFeed(_priceFeedAddress);
        amm = IVirtualAMM(_ammAddress);
    }

    function openPosition(address _user, uint256 _collateral, uint8 _leverage, bool _isLong) public {
        require(vault.lockBalance(_user, _collateral));
        require(!positions[_user].isOpen, "Position already open");
        require(_leverage > 0 && _leverage <=50, "Invalid Leverage");
        require(_collateral > 0, "Colateraal should be greater than 0");

        uint256 _entryPrice = amm.getVirtualAMMPrice();
        uint256 _size = _collateral * _leverage;

        Position memory position = Position({
            user: _user,
            collateral: _collateral,
            size: _size, 
            entryPrice: _entryPrice,
            leverage: _leverage,
            isLong: _isLong,
            isOpen: true
        });

        positions[_user] = position;

        if (_isLong) {
            amm.buy(_user,_collateral, _size, _entryPrice, _leverage);
        } else {
            amm.sell(_user,_collateral, _size, _entryPrice, _leverage);
        }

        emit OpenPosition(_user, _collateral, _entryPrice, _leverage, _size, _isLong);
    }

    function closePosition(address _user) public {}

    function getPosition(address _user) public view returns (Position memory) {
        return positions[_user];
    }

    function calculatePnL(
        Position memory _position
    ) internal returns (int256) {}
}
