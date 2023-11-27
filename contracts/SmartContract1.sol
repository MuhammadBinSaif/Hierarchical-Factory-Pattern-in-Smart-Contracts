// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./AccessControlManager.sol";
contract SmartContract1{
    AccessControlManager private accessControlManager;
    // constructor to recieve the access control manager contract address
    constructor(address _accesscontroladdress)
    {
        accessControlManager = AccessControlManager(_accesscontroladdress);
    }
    // Modifier to check all three role against caller
    modifier checkRole() 
    {
        require(accessControlManager.hasRole(accessControlManager.CLIENT_ROLE(), msg.sender)||accessControlManager.hasRole(accessControlManager.ADMIN_ROLE(), msg.sender)||accessControlManager.hasRole(accessControlManager.USER_ROLE(), msg.sender), "NA");
        _;
    }
    //custom function inside smart contract
    function function1() 
    external 
    view
    checkRole() 
    returns (string memory) 
    {
        return ("Function inside smart contract");
    } 
}