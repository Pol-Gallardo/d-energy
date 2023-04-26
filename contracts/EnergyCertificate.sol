// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./SolarPanel.sol";

contract EnergyCertificate is ERC721Enumerable {
    
    address public solarPanelAddress; // dirección del contrato SolarPanel
    
    uint256 public energyThreshold = 1000000; // valor en MWh para crear un nuevo certificado
    
    uint256 public lastCertificateEnergy; // variable para registrar la última cantidad de energía utilizada para crear el certificado
    
    // evento que se emite cada vez que se crea un nuevo certificado
    event CertificateCreated(address indexed owner, uint256 indexed tokenId, uint256 energyAmount);

    // constructor del contrato, se pasa la dirección del contrato SolarPanel
    constructor(address _solarPanelAddress) ERC721("EnergyCertificate", "EC") {
        solarPanelAddress = _solarPanelAddress;
    }
    
    // función para verificar si se puede crear un nuevo certificado
    function canCreateCertificate() public view returns(bool) {
        return SolarPanel(solarPanelAddress).energyGenerated() >= (lastCertificateEnergy + energyThreshold);
    }
    
    // función para crear un nuevo certificado
    function createCertificate() public returns(uint256) {
        require(canCreateCertificate(), "Cannot create new certificate yet");
        
        // se obtiene la cantidad de energía generada desde la última creación de certificado
        uint256 energyAmount = SolarPanel(solarPanelAddress).energyGenerated() - lastCertificateEnergy;
        
        // se actualiza la variable para registrar la última cantidad de energía utilizada para crear el certificado
        lastCertificateEnergy = SolarPanel(solarPanelAddress).energyGenerated();
        
        // se crea un nuevo certificado ERC721
        uint256 tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);
        
        // se emite el evento de creación de certificado
        emit CertificateCreated(msg.sender, tokenId, energyAmount);
        
        return tokenId;
    }
}
