// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './interfaces/ILiquidityValueCalculator.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';

contract LiquidityValueCalculator is ILiquidityValueCalculator {
    address public factory; // 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f-- address of factory of uniswap deployed
    address tokenA = 0xCAFE000000000000000000000000000000000000; 
    address tokenB = 0xF00D000000000000000000000000000000000000;
    // To add the factory
    constructor(address factory_) public {
        factory = factory_;
    }
    //To record the event when the pair is created
    event PairCreated(address indexed tokenA, address indexed tokenB, address pair, uint);
    // To create Pair of the tokens made and emit it 
    function createPair() external returns (address pair){
        pair = IUniswapV2Factory(factory).createPair(tokenA, tokenB);
        emit PairCreated(tokenA, tokenB, pair, block.timestamp);
    };
    // To get the information about a Uniswap V2 pair of ERC20 tokens created such as the address of pair,
    // the total supply of liquidity tokens for the pair, reserves(The amount of token held in the liquidity pool) and  sorts the reserve amounts.
    function pairInfo() internal view returns (uint reserveA, uint reserveB, uint totalSupply) {
        IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, tokenB));
        totalSupply = pair.totalSupply();
        (uint reserves0, uint reserves1,) = pair.getReserves();
        (reserveA, reserveB) = tokenA == pair.token0() ? (reserves0, reserves1) : (reserves1, reserves0);
    }
    // Calculate token amounts based on the liquidity shares
    function computeLiquidityShareValue(uint liquidity) external view override returns (uint tokenAAmount, uint tokenBAmount) {
    (uint reserveA, uint reserveB, uint totalSupply) = pairInfo();
    require(address(pair) != address(0), "Pair does not exist");
    tokenAAmount = (liquidity * reserveA) / pair.totalSupply();
    tokenBAmount = (liquidity * reserveB) / pair.totalSupply();
    } 

}
