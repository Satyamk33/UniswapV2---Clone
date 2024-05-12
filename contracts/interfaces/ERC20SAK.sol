// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract SakToken is ERC20 {

    constructor() ERC20("SK","SAK"){
        _mint(msg.sender, 100000 * 10 ** decimals());
    }
}