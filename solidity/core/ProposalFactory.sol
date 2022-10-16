// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
  * @author cryptotwilight 
  */
import "https://github.com/Block-Star-Logic/open-roles/blob/b05dc8c6990fd6ba4f0b189e359ef762118d6cbe/blockchain_ethereum/solidity/v2/contracts/core/OpenRolesSecureCore.sol";
import "https://github.com/Block-Star-Logic/open-roles/blockchain_ethereum/solidity/v2/contracts/interfaces/IOpenRolesManaged.sol";

import "https://github.com/Block-Star-Logic/open-register/blob/0959ffa2af2ca2cb3e5dd0f7b495e831cca2d506/blockchain_ethereum/solidity/V1/interfaces/IOpenRegister.sol";

import  "../interface/IProposalFactory.sol";
import "./Proposal.sol";

/**
 * @dev IProposalFactory implementation 
 */
contract ProposalFactory is OpenRolesSecureCore, IProposalFactory, IOpenVersion, IOpenRolesManaged { 


    IOpenRegister registry;     

    string constant name     = "RESERVED_DESIGN_PROPOSAL_FACTORY_CORE"; 
    uint256 constant version = 3; 

    string constant registryCA        = "RESERVED_OPEN_REGISTER_CORE";  
    string constant roleManagerCA     = "RESERVED_OPEN_ROLES_CORE";

    string constant designProposalCA  = "RESERVED_DESIGN_PROPOSAL_CORE";
    
    string constant openAdminRole            = "OPEN_ADMIN_ROLE";
    string constant designProposalCoreRole   = "DESIGN_PROPOSAL_CORE_ROLE";

    string [] roleNames = [openAdminRole, designProposalCoreRole];

    address [] proposals; 
    mapping(address=>bool) knownProposals; 

    mapping(string=>bool) hasDefaultFunctionsByRole;
    mapping(string=>string[]) defaultFunctionsByRole;

    constructor(address _registry, string memory _dappName) OpenRolesSecureCore(_dappName) {
        registry = IOpenRegister(_registry);
        
        setRoleManager(registry.getAddress(roleManagerCA));
        
        addConfigurationItem(address(registry));   
        addConfigurationItem(address(roleManager));   

        initFunctionsForRoles();      
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
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

    function createProposal(ProposalSeed memory _seed)  payable external returns (address _proposal){
        require(isSecure(designProposalCoreRole, "createProposal"), "dp core only");
        return createProposalInternal(_seed);                 
    }

    function getProposals() view external returns (address [] memory _proposals) {
        require(isSecure(openAdminRole, "getProposals")," admin only ");    
        return proposals; 
    }

    function isKnownProposal(address _proposal) view external returns (bool) {
         require(isSecure(openAdminRole, "isKnownProposal")," admin only ");    
        return knownProposals[_proposal];
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
        defaultFunctionsByRole[openAdminRole].push("getProposals");
        defaultFunctionsByRole[openAdminRole].push("isKnownProposal");

        hasDefaultFunctionsByRole[designProposalCoreRole] = true; 
        defaultFunctionsByRole[designProposalCoreRole].push("createProposal");
        return true; 
    }

    function createProposalInternal(ProposalSeed memory _seed) internal returns (address _proposal) {
        Proposal proposal_ = new Proposal(address(registry), _seed );
        _proposal = address(proposal_);
        proposals.push(_proposal);
        knownProposals[_proposal] = true; 
        registry.registerDerivativeAddress(_proposal, "PROPOSAL_TYPE");
        return _proposal;     
    }
}