// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
  * @author cryptotwilight 
  */
import "https://github.com/Block-Star-Logic/open-roles/blob/b05dc8c6990fd6ba4f0b189e359ef762118d6cbe/blockchain_ethereum/solidity/v2/contracts/core/OpenRolesSecureCore.sol";
import "https://github.com/Block-Star-Logic/open-roles/blockchain_ethereum/solidity/v2/contracts/interfaces/IOpenRolesManaged.sol";

import "https://github.com/Block-Star-Logic/open-register/blob/0959ffa2af2ca2cb3e5dd0f7b495e831cca2d506/blockchain_ethereum/solidity/V1/interfaces/IOpenRegister.sol";

import "../interface/ISectionFactory.sol";
import "./Section.sol";

/**
 * @dev ISectionFactory implementation 
 */
contract SectionFactory is ISectionFactory, OpenRolesSecureCore, IOpenRolesManaged { 

    using LOpenUtilities for string; 

    IOpenRegister registry;     

    string name     = "RESERVED_DESIGN_PROPOSAL_SECTION_FACTORY_CORE"; 
    uint256 version = 3; 

    string registryCA        = "RESERVED_OPEN_REGISTER_CORE";  
    string roleManagerCA     = "RESERVED_OPEN_ROLES_CORE";

    string designProposalCA  = "RESERVED_DESIGN_PROPOSAL_CORE";
    
    string openAdminRole            = "OPEN_ADMIN_ROLE";
    string designProposalCoreRole   = "DESIGN_PROPOSAL_CORE_ROLE";

    string [] roleNames = [openAdminRole, designProposalCoreRole];

    address [] sections; 
    mapping(address=>bool) knownSections; 

    mapping(string=>bool) hasDefaultFunctionsByRole;
    mapping(string=>string[]) defaultFunctionsByRole;


    constructor(address _registry, string memory _dappName) OpenRolesSecureCore(_dappName) {
        registry = IOpenRegister(_registry);
        
        setRoleManager(registry.getAddress(roleManagerCA));
        
        addConfigurationItem(address(registry));   
        addConfigurationItem(address(roleManager));   

        initFunctionsForRoles();      
    }

    function getName() view external returns (string memory _name) {
        return name; 
    }

    function getVersion() view external returns (uint256 _version) {
        return version; 
    }

    function getDefaultRoles() override view external returns (string [] memory _roles){    
        return  roleNames; 
    }

    function hasDefaultFunctions(string memory _role) override view external returns(bool _hasFunctions){
        return hasDefaultFunctionsByRole[_role];
    }

    function getDefaultFunctions(string memory _role) override view external returns (string [] memory _functions){
        return defaultFunctionsByRole[_role];
    }

    function createSection( uint256 _id, 
                            address _proposal, 
                            address _originator, 
                            string memory _title, 
                            string memory _contentIpfsHash, 
                            uint256 _voteCycleTime) external returns (address _section){
                            require(registry.isDerivativeAddress(msg.sender), " unknown derivative address ");
                            require(registry.getDerivativeAddressType(msg.sender).isEqual("PROPOSAL_TYPE")," unknown derivative type" );
                        
                            
                            Section section_ = new Section( _id,
                                                            _proposal,   
                                                            _originator,                                                                 
                                                            _title, 
                                                            _contentIpfsHash, 
                                                            _voteCycleTime);
                            _section = address(section_);
                            registry.registerDerivativeAddress(_section, "SECTION_TYPE");
                            sections.push(_section);
                            knownSections[_section] = true;
                            return _section; 
    }

    function getSections() view external returns (address [] memory _proposals) {
        require(isSecure(openAdminRole, "getSections")," admin only ");    
        return sections; 
    }

    function isKnownSection(address _section) view external returns (bool) {
         require(isSecure(openAdminRole, "isKnownSection")," admin only ");    
        return knownSections[_section];
    }
    
    function notifyChangeOfAddress() external returns (bool _recieved){
        require(isSecure(openAdminRole, "notifyChangeOfAddress")," admin only ");    
        registry                = IOpenRegister(registry.getAddress(registryCA)); // make sure this is NOT a zero address       
        roleManager             = IOpenRoles(registry.getAddress(roleManagerCA));                

        addConfigurationItem(address(registry));   
        addConfigurationItem(address(roleManager));         
        return true; 
    }
    
    //=========================================== INTERNAL ========================================================================  

    function initFunctionsForRoles() internal returns (bool _initiated) {
        
        hasDefaultFunctionsByRole[openAdminRole] = true; 
        defaultFunctionsByRole[openAdminRole].push("notifyChangeOfAddress");
        defaultFunctionsByRole[openAdminRole].push("getSections");
        defaultFunctionsByRole[openAdminRole].push("isKnownSection");

        hasDefaultFunctionsByRole[designProposalCoreRole] = true; 
        defaultFunctionsByRole[designProposalCoreRole].push("createProposal");
        return true; 
    }

}