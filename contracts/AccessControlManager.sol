// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "./SuperFactory.sol";
contract AccessControlManager{
    // ECDSA library to recover user address from signature
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;
    // roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
    bytes32 public constant CLIENT_ROLE = keccak256("CLIENT");
    bytes32 public constant USER_ROLE = keccak256("USER");
    address private AdminOwner;
    // struct for contract data
    struct ContractData { 
        address contractAddress; // 20 bytes 
        address ownerAddress; // 20 bytes 
        address parentContractAddress; // 20 bytes 
        bytes32 ownerName; // 32 bytes 
        bytes32 name; // 32 bytes 
        bytes32 parentName; // 32 bytes 
        ContractType contractType; // enum, 1 byte 
    }
    // enum for contract types
    enum ContractType {ACM,superfactory,clientfactory1,clientfactory2,clientfactory3,smartcontract1}
    // mapping to store roles against users and contracts
    mapping (bytes32 => mapping (address => ContractData[])) private accesscontrol;
    // constructor to initialize and deploy super factory with deployer address as ADMIN
    constructor() 
    {
        createNewContract(ADMIN_ROLE, msg.sender, address(this), msg.sender, address(this), "ACM", "ACM", "ACM", ContractType.ACM);
        createNewContract(ADMIN_ROLE, msg.sender, address(new SuperFactory(address(this))), msg.sender, address(this), "Super_Factory", "Super_Factory", "Super_Factory", ContractType.superfactory);
        AdminOwner = msg.sender;
    }
    // modifier to check the admin role
    modifier onlyAdmin() 
    {
        require(hasRole(ADMIN_ROLE, msg.sender), "NA");
        _;
    }
    // modifier to check the client role
    modifier onlyClient() 
    {
        require(hasRole(CLIENT_ROLE, msg.sender), "NA");
        _;
    }
    // internal function to recover user address from signature  
    function _verify(
        bytes32 data, 
        bytes calldata signature
    ) 
    internal 
    pure 
    returns (address) 
    {
        return data
        .toEthSignedMessageHash()
        .recover(signature);
    }
    // public function to check user roles against contract address 
    function hasRole(
        bytes32 _role, 
        address _user
    ) 
    public 
    view 
    returns (bool) 
    {
        ContractData[] memory contracts = accesscontrol[_role][_user];
        return contracts.length > 0;
    }
    // external function to get contract address against admin role  
    function getAdminContracts() 
    external
    view  
    onlyAdmin() 
    returns (ContractData[] memory) 
    {
        return accesscontrol[ADMIN_ROLE][msg.sender];
    }
    // external function to get contract address against client role  
    function adminGetClientContracts(address _client_address) 
    external
    view  
    onlyAdmin() 
    returns (ContractData[] memory) 
    {
        return accesscontrol[CLIENT_ROLE][_client_address];
    }
    // external function to add new contracts in mapping on behalf of client user
    function addClientContract(
        address _contract_address,
        address _owner_address,
        address _parent_address,  
        bytes32 _owner_name, 
        bytes32 _name,
        bytes32 _parent_name,
        bytes32 _data,
        bytes calldata _signature, 
        ContractType _contract_type
    ) 
    external
    {
        address signer =  _verify(_data,_signature);
        require(hasRole(ADMIN_ROLE, signer), "NA");
        createNewContract(CLIENT_ROLE, _owner_address, _contract_address, _owner_address, _parent_address, _owner_name, _name, _parent_name, _contract_type);
        createNewContract(ADMIN_ROLE, signer,_contract_address, _owner_address, _parent_address, _owner_name, _name, _parent_name, _contract_type);
    }
    // external function to update contract data struct and also user against specific contract
    function updateClientContracts(
        address _oldaddress, 
        address _newaddress, 
        address _parent_address,
        bytes32 _parent_name,
        uint256 _admin_index, 
        uint256 _client_index,
        bytes32 _name, 
        uint8 _check
    ) 
    external 
    onlyAdmin()
    {
        ContractData[] storage clientcontracts = accesscontrol[CLIENT_ROLE][_oldaddress];
        require(clientcontracts.length > 0, "I addr");
        require(_client_index < clientcontracts.length, "I index");
        ContractData[] storage admincontracts = accesscontrol[ADMIN_ROLE][AdminOwner];
        clientcontracts[_client_index].name = _name;
        admincontracts[_admin_index].name = _name;
        clientcontracts[_client_index].parentContractAddress = _parent_address;
        admincontracts[_admin_index].parentContractAddress = _parent_address;
        clientcontracts[_client_index].parentName = _parent_name;
        admincontracts[_admin_index].parentName = _parent_name;
        if(_check != 0) {
            for (uint i = 0; i < clientcontracts.length; i++) {
                if (clientcontracts[i].ownerAddress == _oldaddress) {
                    if(_oldaddress != _newaddress){
                        clientcontracts[i].ownerAddress = _newaddress;
                    }
                    clientcontracts[i].ownerName = _name;
                }
            }
            for (uint i = 2; i < admincontracts.length; i++) {
                if (admincontracts[i].ownerAddress == _oldaddress) {
                    if(_oldaddress != _newaddress){
                        admincontracts[i].ownerAddress = _newaddress;
                    }
                    admincontracts[i].ownerName = _name;
                }
            }
            if(_oldaddress != _newaddress){
                accesscontrol[CLIENT_ROLE][_newaddress] = clientcontracts;
                require(
                    accesscontrol[CLIENT_ROLE][_newaddress].length == clientcontracts.length,
                    "NS"
                );
                delete accesscontrol[CLIENT_ROLE][_oldaddress];
            }
        }
    }
    // external function called by client to add new contracts and data in struct mapping      
    function addClientContracts(
        bytes32 _name, 
        bytes32 _owner_name, 
        address _contract_address, 
        ContractType _contract_type, 
        address _parent_contract_address, 
        bytes32 _parent_name, 
        bytes32 _data, 
        bytes calldata _signature
    ) 
    external
    {
        address signer =  _verify(_data,_signature);
        require(hasRole(CLIENT_ROLE, signer), "client");
        ContractData memory newcontract = ContractData({
            contractAddress: _contract_address,
            ownerAddress: signer,
            parentContractAddress: _parent_contract_address,
            ownerName: _owner_name,
            name: _name,
            parentName: _parent_name,
            contractType: _contract_type
        });
        accesscontrol[CLIENT_ROLE][signer].push(newcontract);
        accesscontrol[ADMIN_ROLE][AdminOwner].push(newcontract);
    }
    // external function to get contracts against client users
    function getClientContracts() 
    external
    view  
    onlyClient() 
    returns (ContractData[] memory) 
    {
        return accesscontrol[CLIENT_ROLE][msg.sender];
    }
    // seprate private function to add contract data in struct
    // purpose of this function is to remove code repetition  
    function createNewContract(
        bytes32 _role, 
        address _user, 
        address _contract_address, 
        address _owner_address, 
        address _parent_address,
        bytes32 _owner_name, 
        bytes32 _name, 
        bytes32 _parent_name, 
        ContractType _contract_type
    ) 
    private
    {
        ContractData memory newcontract = ContractData({
            contractAddress: _contract_address,
            ownerAddress: _owner_address,
            parentContractAddress: _parent_address,
            ownerName: _owner_name,
            name: _name,
            parentName: _parent_name,
            contractType: _contract_type
        });
        accesscontrol[_role][_user].push(newcontract);
    }
}
