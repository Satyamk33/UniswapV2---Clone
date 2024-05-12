// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ILiquidityValueCalculator {
    function computeLiquidityShareValue(uint liquidity, address tokenA, address tokenB) external returns (uint tokenAAmount, uint tokenBAmount);
}