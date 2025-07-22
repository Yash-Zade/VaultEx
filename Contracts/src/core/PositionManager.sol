// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PositionManager {
    
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

    event OpenPosition(
        address indexed _user,
        uint256 collateral,
        uint entryPrice,
        uint8 leverage,
        uint256 size,
        bool isLong
    );
    event ClosePosition(
        address indexed user,
        uint256 entryPrice,
        uint256 exitPrice,
        int256 pnl,
        bool isLong
    );

    function openPosition(
        address _user,
        uint256 collateral,
        uint entryPrice,
        uint8 leverage,
        bool isLong
    ) public {}

    function closePosition(address _user) public {}

    function getPosition(address _user) public view returns (Position memory) {
        return positions[_user];
    }

    function calculatePnL(
        Position memory _position
    ) internal returns (int256) {}
}
