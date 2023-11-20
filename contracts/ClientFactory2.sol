// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./AccessControlManager.sol";
import "./ClientFactory3.sol";

contract ClientFactory2{
    AccessControlManager private accessControlManager;
    constructor(address _accesscontroladdress)
    {
        accessControlManager = AccessControlManager(_accesscontroladdress);
    }
    modifier checkClient() 
    {
        require(accessControlManager.hasRole(accessControlManager.CLIENT_ROLE(), msg.sender), "NA");
        _;
    }
    function createClientFactory3(bytes32 _client2_name, bytes32 _owner_name, address _parent_address, bytes32 _parent_name, bytes32 _data, bytes memory _signature) 
    external 
    checkClient() 
    {
        accessControlManager.addClientContracts(_client2_name, _owner_name, address(new ClientFactory3(address(accessControlManager))), AccessControlManager.ContractType.clientfactory3, _parent_address, _parent_name, _data, _signature);
    }
}