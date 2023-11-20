// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./ClientFactory2.sol";

//library to split the code from super facotry to reduce bytecode size
library ClientLibrary2 {
    function createClientFactory2(address controlAddress) external returns (address) {
        return address(new ClientFactory2(controlAddress));
    }
}
