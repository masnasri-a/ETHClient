// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Halal{
    event success(string status, bytes32 message);

    address public owner;

    struct accountData {
        string account_id;
        string name;
        string role;
        uint created_at;
    }

    mapping( bytes32 => accountData ) private mappingAccount; 

    struct transaction{
        string user_id;
        bytes data;
    }

    mapping (bytes32 => transaction) private mappingTransaction;

    struct certificate{
        string umkm_id;
        string certificate_id;
        uint created_at;
        uint expired_at;
    }

    mapping (bytes32 => certificate) private mappingCertificate;

    constructor(){
        owner = msg.sender;
    }

    function account_checker(bytes32 id, string memory umkm_id) private view returns(bool){
        return keccak256(abi.encodePacked(mappingAccount[id].account_id)) != keccak256(abi.encodePacked(umkm_id));
    }

    function add_account(
        string memory account_id,
        string memory name,
        string memory role
    ) external returns(bytes32){
        bytes32 id = keccak256(abi.encodePacked(account_id));
        require(account_checker(id, account_id), "Account already existing");
        accountData storage acc = mappingAccount[id];
        acc.account_id = account_id;
        acc.name = name;
        acc.role = role;
        acc.created_at = block.timestamp;
        emit success("success", id);
        return id;
    }

    function get_account(string memory account_id) public view returns(accountData memory){
        bytes32 id = keccak256(abi.encodePacked(account_id));
        return mappingAccount[id];
    }

    function add_transaction(
        string memory transaction_id,
        string memory user_id,
        bytes memory data
    ) external returns(bytes32) {
        bytes32 id = keccak256(abi.encodePacked(transaction_id));
        transaction memory trans = mappingTransaction[id];
        trans.user_id = user_id;
        trans.data = data;
        emit success("success", id);
        return id;
    }

    function get_transaction(string memory transaction_id) external view returns(transaction memory){
        bytes32 id = keccak256(abi.encodePacked(transaction_id));
        return mappingTransaction[id]; 
    }

    function add_certificate(string memory umkm_id, string memory cert_id, uint expired_at) external returns(bytes32){
        bytes32 id = keccak256(abi.encodePacked(umkm_id));
        certificate memory cert = mappingCertificate[id];
        cert.umkm_id = umkm_id;
        cert.certificate_id = cert_id;
        cert.created_at = block.timestamp;
        cert.expired_at = expired_at;
        emit success("success", id);
        return id;
    }

    function get_certificate(string memory umkm_id) external view returns(certificate memory){
        bytes32 id = keccak256(abi.encodePacked(umkm_id));
        return mappingCertificate[id];
    }

}