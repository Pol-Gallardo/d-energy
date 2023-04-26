// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolarPanel {
    
    uint256 public energyGenerated; // variable para registrar la energía generada
    
    // evento que se emite cada vez que se registra energía generada
    event EnergyGenerated(uint256 amount);

    // función para registrar la energía generada
    function registerEnergy(uint256 amount) public {
        energyGenerated += amount;
        emit EnergyGenerated(amount);
    }
}