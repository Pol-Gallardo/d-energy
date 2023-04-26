// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "remix_tests.sol";
import "../contracts/SolarPanel.sol";
import "../contracts/EnergyCertificate.sol";

contract TestEnergyCertificate {
    
    SolarPanel public solarPanel;
    EnergyCertificate public energyCertificate;
    
    function beforeEach() public {
        solarPanel = new SolarPanel();
        energyCertificate = new EnergyCertificate(address(solarPanel));
    }
    
    function testCanCreateCertificate() public {
        // Se genera energía en el SolarPanel
        solarPanel.registerEnergy(500000);
        
        // Comprobamos que no se puede crear el certificado todavía
        Assert.equal(energyCertificate.canCreateCertificate(), false, "Should not be able to create certificate yet");
        
        // Se genera más energía para llegar al umbral
        solarPanel.registerEnergy(500001);
        
        // Comprobamos que ahora sí se puede crear el certificado
        Assert.equal(energyCertificate.canCreateCertificate(), true, "Should be able to create certificate now");
    }
    
    function testCreateCertificate() public {
        // Se genera energía en el SolarPanel
        solarPanel.registerEnergy(2000000);
        
        // Se crea el certificado
        uint256 tokenId = energyCertificate.createCertificate();
        
        // Comprobamos que se ha creado correctamente
        Assert.equal(energyCertificate.ownerOf(tokenId), address(this), "Certificate owner should be the test contract");
        Assert.equal(energyCertificate.totalSupply(), 1, "Total supply should be 1");
        Assert.equal(solarPanel.energyGenerated(), 2000000, "Energy generated should be 2000000");
        Assert.equal(energyCertificate.lastCertificateEnergy(), 2000000, "Last certificate energy should be 2000000");
    }
}

