// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';


contract Swap{
    address tokenA = 0xCAFE000000000000000000000000000000000000; 
    address tokenB = 0xF00D000000000000000000000000000000000000;
    address public owner = 0xA00000000000000000000000000000000;// adddress where fee goes 
    address[] public path; 
// Initialize Router
    IUniswapV2Router02 public router; //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D 
    constructor(address _router) {
        router = IUniswapV2Router02(_router);
         path = [tokenA, WETHAddress, tokenB];
    }


//Now we know that UniswapV2 actually first converts the tokenA to WETH and then that WETH to tokenB So we need liquidity for both tokens
 function addLiquidity(
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity) {
        // Ensure that the provided deadline has not passed
        require(block.timestamp <= deadline, 'LiquidityProvider: Deadline has passed');

        // Approve the router to spend tokens on behalf of this contract
        IERC20(tokenA).approve(address(router), amountADesired);
        IERC20(tokenB).approve(address(router), amountBDesired);

        // Add liquidity to the pool
        (amountA, amountB, liquidity) = router.addLiquidity(
            tokenA,
            tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            msg.sender,
            deadline
        );
        
    }

    
    function addLiquidityETH(
        address token, // specify wwhich token are you giving for 
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity) {
        // Ensure that the provided deadline has not passed
        require(block.timestamp <= deadline, 'LiquidityProviderETH: Deadline has passed');

        // Approve the router to spend tokens on behalf of this contract
        IERC20(token).approve(address(router), amountTokenDesired);

        // Add liquidity to the pool with ETH
        (amountToken, amountETH, liquidity) = router.addLiquidityETH{value: msg.value}(
            token,
            amountTokenDesired,
            amountTokenMin,
            amountETHMin,
            msg.sender,
            deadline
        );
    }

// Swaps an exact amount of input tokens for as many output tokens as possible
function swapExactTokensForTokens(
  uint amountIn,
  uint amountOutMin,
  uint deadline
) external returns (uint[] memory amounts){
return router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, deadline);
}

// Receive an exact amount of output tokens for as few input tokens as possible
function swapTokensForExactTokens(
  uint amountOut,
  uint amountInMax,
  uint deadline
) external returns (uint[] memory amounts){
    return router.swapTokensForExactTokens(amountOut, amountInMax, path, msg.sender, deadline);
}

// To charge fee when swapping 

 function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        uint deadline
    ) external {
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountIn,
            amountOutMin,
            path,
            msg.sender,
            deadline
        );
    }

    
}