// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Rupees is ERC20("Rupees", "RS") {
    constructor() {
        _mint(0xcF01971DB0CAB2CBeE4A8C21BB7638aC1FA1c38c, 1000 * 1e18);
    }
}
