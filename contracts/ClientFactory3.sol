// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./AccessControlManager.sol";
import "./SmartContract1.sol";

contract ClientFactory3{
    AccessControlManager private accessControlManager;
    // constructor to recieve the access control manager contract address
    constructor(address _accesscontroladdress)
    {
        accessControlManager = AccessControlManager(_accesscontroladdress);
    }
    // Modifier to check client role against caller
    modifier checkClient() 
    {
        require(accessControlManager.hasRole(accessControlManager.CLIENT_ROLE(), msg.sender)||accessControlManager.hasRole(accessControlManager.ADMIN_ROLE(), msg.sender)||accessControlManager.hasRole(accessControlManager.USER_ROLE(), msg.sender), "NA");
        _;
    }
    // Function to create sub factory
    function createSmartContract1(bytes32 _smartcontract1_name, bytes32 _owner_name, address _parent_address, bytes32 _parent_name, bytes32 _data, bytes memory _signature) 
    external 
    checkClient() 
    {
        accessControlManager.createNewContract(_smartcontract1_name, _owner_name, address(new SmartContract1(address(accessControlManager))), AccessControlManager.ContractType.smartcontract1, _parent_address, _parent_name, _data, _signature);
    }
    //Custom Function belongs to Client Factory 3
    function customFunction1() 
    external 
    view
    checkClient() 
    returns (string memory) 
    {
        return ("Function inside factory 3 smart contract");
    }
}