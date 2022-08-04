// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; // Compilers below that version will not recognise the code
pragma experimental ABIEncoderV2;

contract cardealership {

    struct Car {
        string car;
        string ownerName;
        uint256 price;
    }
    
    // Address of the owner
    // Dirección del dueño
    address public owner;

    // Mapping that relates a car and his price
    // Mapping para relacionar un coche y su precio
    mapping (bytes32 => Car) cars;

    modifier onlyOwner(address _address) {
        // The _address must the one of the owner
        // La _address debe ser la del dueño
        require(_address == owner, "You are not the owner");
        _;
    }

    // Setting the owner of the dealership
    // Establecemos el dueño de la tienda
    constructor () { owner = msg.sender; }

    // Function to add a car
    // Función para añadir un coche
    function addCar(string memory _carName, string memory _ownerName, uint _price) public onlyOwner(msg.sender) {
        bytes32 hashOwnerName = keccak256(abi.encodePacked(_carName));
        cars[hashOwnerName] = Car(_carName, _ownerName, _price);
    }

    // Function to see a car
    // Function to add a car
    function seeCar(string memory _carName) public view returns(Car memory) {
        bytes32 hashOwnerName = keccak256(abi.encodePacked(_carName));
        return cars[hashOwnerName];
    }   
}