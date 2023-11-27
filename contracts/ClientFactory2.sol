// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./AccessControlManager.sol";
import "./ClientFactory3.sol";

contract ClientFactory2{
    AccessControlManager private accessControlManager;
    // constructor to recieve the access control manager contract address
    constructor(address _accesscontroladdress)
    {
        accessControlManager = AccessControlManager(_accesscontroladdress);
    }
    // Modifier to check client role against caller
    modifier checkClient() 
    {
        require(accessControlManager.hasRole(accessControlManager.CLIENT_ROLE(), msg.sender), "NA");
        _;
    }
    // Function to create sub factory
    function createClientFactory3(bytes32 _client2_name, bytes32 _owner_name, address _parent_address, bytes32 _parent_name, bytes32 _data, bytes memory _signature) 
    external 
    checkClient() 
    {
        accessControlManager.createNewContract(_client2_name, _owner_name, address(new ClientFactory3(address(accessControlManager))), AccessControlManager.ContractType.clientfactory3, _parent_address, _parent_name, _data, _signature);
    }
    //Custom Function belongs to Client Factory 2
    function customFunction1() 
    external 
    view
    checkClient() 
    returns (string memory) 
    {
        return ("Function inside factory 2 smart contract");
    }
}