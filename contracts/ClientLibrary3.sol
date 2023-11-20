// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./ClientFactory3.sol";

//library to split the code from super facotry to reduce bytecode size
library ClientLibrary3 {
    function createClientFactory3(address controlAddress) external returns (address) {
        return address(new ClientFactory3(controlAddress));
    }
}

