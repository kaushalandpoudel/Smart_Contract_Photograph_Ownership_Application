pragma solidity ^0.4.25;
contract major{
    string photographId;
    string photographIPFSAddress;

    constructor (string memory id) public{
        photographId = id;
    }

    function setAddress(string memory IPFSAddress) public{
        photographIPFSAddress = IPFSAddress;
    }

    function getAddress() public view returns(string memory){
        return photographIPFSAddress;
    }

    function getId() public view returns(string memory){
        return photographId;
    }
}