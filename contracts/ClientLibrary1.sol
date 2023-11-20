// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ClientFactory1.sol";

library ClientLibrary1 {
    function createClientFactory1(address controlAddress) external returns (address) {
        return address(new ClientFactory1(controlAddress));
    }
}