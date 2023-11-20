// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./AccessControlManager.sol";
import "./SmartContract1.sol";

contract ClientFactory3{
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
    function createSmartContract1(bytes32 _smartcontract1_name, bytes32 _owner_name, address _parent_address, bytes32 _parent_name, bytes32 _data, bytes memory _signature) 
    external 
    checkClient() 
    {
        accessControlManager.addClientContracts(_smartcontract1_name, _owner_name, address(new SmartContract1(address(accessControlManager))), AccessControlManager.ContractType.smartcontract1, _parent_address, _parent_name, _data, _signature);
    }
}