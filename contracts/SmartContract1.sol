// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./AccessControlManager.sol";
contract SmartContract1{
    AccessControlManager private accessControlManager;
    
    constructor(address _accesscontroladdress)
    {
        accessControlManager = AccessControlManager(_accesscontroladdress);
    }
    modifier checkClient() 
    {
        require(accessControlManager.hasRole(accessControlManager.CLIENT_ROLE(), msg.sender)||accessControlManager.hasRole(accessControlManager.ADMIN_ROLE(), msg.sender)||accessControlManager.hasRole(accessControlManager.USER_ROLE(), msg.sender), "NA");
        _;
    }

    function function1() 
    external 
    view
    checkClient() 
    returns (string memory) 
    {
        return ("Function inside smart contract");
    } 
}