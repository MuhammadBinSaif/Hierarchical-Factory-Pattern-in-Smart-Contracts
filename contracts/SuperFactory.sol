// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AccessControlManager.sol";
import "./ClientLibrary1.sol";
import "./ClientLibrary2.sol";
import "./ClientLibrary3.sol";

contract SuperFactory {
    AccessControlManager private accessControlManager;

    constructor(address _accesscontroladdress) {
        accessControlManager = AccessControlManager(_accesscontroladdress);
    }

    modifier checkAdmin() {
        require(accessControlManager.hasRole(accessControlManager.ADMIN_ROLE(), msg.sender), "NA");
        _;
    }

    function createClientContracts(
        address _client_owner_address,
        address _parent_address,
        bytes32 _owner_name,
        bytes32 _name,
        bytes32 _parent_name,
        bytes32 _data,
        bytes calldata _signature,
        uint _contract_type
    ) external checkAdmin() {
        address contractAddress;
        if (_contract_type == 2) {
            contractAddress = ClientLibrary1.createClientFactory1(address(accessControlManager));
        } else if (_contract_type == 3) {
            contractAddress = ClientLibrary2.createClientFactory2(address(accessControlManager));
        } else {
            contractAddress = ClientLibrary3.createClientFactory3(address(accessControlManager));
        } 
        accessControlManager.addClientContract(
            contractAddress,
            _client_owner_address,
            _parent_address,
            _owner_name,
            _name,
            _parent_name,
            _data,
            _signature,
            AccessControlManager.ContractType(_contract_type)
        );
    }
}
