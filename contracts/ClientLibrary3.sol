// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ClientFactory3.sol";

library ClientLibrary3 {
    function createClientFactory3(address controlAddress) external returns (address) {
        return address(new ClientFactory3(controlAddress));
    }
}

