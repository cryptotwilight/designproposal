// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.15;
/** 
  * @author cryptotwilight 
  */
import "https://github.com/Block-Star-Logic/open-libraries/blob/703b21257790c56a61cd0f3d9de3187a9012e2b3/blockchain_ethereum/solidity/V1/libraries/LOpenUtilities.sol";

import "https://github.com/Block-Star-Logic/open-roles/blob/b05dc8c6990fd6ba4f0b189e359ef762118d6cbe/blockchain_ethereum/solidity/v2/contracts/core/OpenRolesSecureCore.sol";
import "https://github.com/Block-Star-Logic/open-roles/blockchain_ethereum/solidity/v2/contracts/interfaces/IOpenRolesManaged.sol";

import "https://github.com/Block-Star-Logic/open-register/blob/0959ffa2af2ca2cb3e5dd0f7b495e831cca2d506/blockchain_ethereum/solidity/V1/interfaces/IOpenRegister.sol";

import "../interface/IDesignProposal.sol";
import "../interface/IDPManagement.sol";
import "../interface/IProposalFactory.sol";
import "../interface/IProposal.sol";

/**
 * @dev IDesignProposal implementation 
 */
contract DesignProposal is OpenRolesSecureCore, IDesignProposal, IDPManagement, IOpenVersion, IOpenRolesManaged { 
        
        using LOpenUtilities for address; 

        string constant name = "RESERVED_DESIGN_PROPOSAL_CORE";
        uint256 constant version = 3; 

        string constant registryCA        = "RESERVED_OPEN_REGISTER_CORE";  
        string constant proposalFactoryCA = "RESERVED_DESIGN_PROPOSAL_FACTORY_CORE";
        string constant roleManagerCA     = "RESERVED_OPEN_ROLES_CORE";

        string constant openAdminRole     = "RESERVED_OPEN_ADMIN_ROLE";
        string constant businessAdminRole = "BUSINESS_ADMIN_ROLE";
        string [] roleNames = [openAdminRole, businessAdminRole];

        IOpenRegister registry; 
        IProposalFactory proposalFactory;

        mapping(string=>bool) hasDefaultFunctionsByRole;
        mapping(string=>string[]) defaultFunctionsByRole;

        address [] proposals; 
        mapping(address=>bool) knownProposal; 
        mapping(address=>address[]) proposalsByOwner; 
        mapping(address=>address[]) proposalsByContributor; 

        string [] daos; 
        mapping(string=>address[]) proposalsByDao; 
        mapping(string=>bool) knownDAO; 


        uint256 price; 
        address currency; 

        constructor(address registry_, string memory _dappName, uint256 _proposalPrice, address _paymentCurrency) OpenRolesSecureCore(_dappName) {
            
            registry = IOpenRegister(registry_);
            setRoleManager(registry.getAddress(roleManagerCA));
            proposalFactory = IProposalFactory(registry.getAddress(proposalFactoryCA));

            price           = _proposalPrice; 
            currency        = _paymentCurrency; 

            addConfigurationItem(address(registry));   
            addConfigurationItem(address(roleManager));         
            addConfigurationItem(address(proposalFactory));  
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

        function getProposalFee() view external returns (uint256 _price, address _currency){
            return (price, currency);
        }

        function getProposals() view external returns (address [] memory _proposals){
            return proposals; 
        }
        
        function getDaos() view external returns (string [] memory _daos){
            return daos; 
        }

        function getProposalsByDAO(string memory _daoName) view external returns (address [] memory _daoNames) {
            return proposalsByDao[_daoName];
        }

        function isKownProposal(address _proposal) view external returns (bool _knownProposal) {
            return knownProposal[_proposal];
        }

        function getProposalByOwner(address _owner) view external returns (address [] memory _proposals){
            return proposalsByOwner[_owner];
        }

        function getProposalsByContributor(address _contributor) view external returns (address [] memory _proposals){
            return proposalsByContributor[_contributor];
        }


        function createProposal(string memory _daoName, 
                                address _owner,
                                string memory _title, 
                                uint256 _targetSubmissionDate, 
                                string memory _backgroundDataLink, 
                                address _currencyAddress, 
                                string [] memory _IPFSpropertyNames, string [] memory _IPFSpropertyValues, 
                                string [] memory _uintPropertyNames, uint256 [] memory _uintPropertyValues ) payable external returns (address _proposal){
                                
                                ProposalSeed memory _seed = ProposalSeed({
                                                                            id                     : getProposalId(),
                                                                            owner                  : _owner,
                                                                            title                  :  _title,
                                                                            targetSubmissionDate   : _targetSubmissionDate,
                                                                            backgroundDataLink     : _backgroundDataLink,
                                                                            currencyAddress        : _currencyAddress,                                                                        
                                                                            IPFSpropertyNames      : _IPFSpropertyNames,  // PROPOSAL_INFO_IPFS_KEY, PROPOSAL_IMAGE_IPFS_KEY, 
                                                                            IPFSpropertyValues     : _IPFSpropertyValues,
                                                                            uintPropertyNames      : _uintPropertyNames,   // VOTE_CYCLE_TIME_KEY, VOTE_FEE_KEY, SECTION_FEE_KEY
                                                                            uintPropertyValues     : _uintPropertyValues
                                                                        });
            _proposal = proposalFactory.createProposal(_seed);                                                    
            proposals.push(_proposal);
            knownProposal[_proposal] = true; 
            proposalsByOwner[_owner].push(_proposal);
            if(!knownDAO[_daoName]) {
                daos.push(_daoName);
            }
            proposalsByDao[_daoName].push(_proposal);
            return _proposal;
        }

        function registerContributor(address _contributor) external returns (bool _registered) {
            checkContributor(_contributor);
            proposalsByContributor[_contributor].push(msg.sender);
            return true; 
        }

        function deregisterContributor(address _contributor) external returns (bool _deregistered) {
            checkContributor(_contributor);
            proposalsByContributor[_contributor] = msg.sender.remove(proposalsByContributor[_contributor]);
            return true;
        }
        
        function updateProposalPrice(uint256 _price) external returns (bool _updated) {
            require(isSecure(businessAdminRole, "updateProposalPrice"), "biz admin only ");
            price = _price; 
            return true; 
        }

        function updateProposalCurrency(address _currency) external returns (bool _updated) {
            require(isSecure(businessAdminRole, "updateProposalCurrency"), "biz admin only ");
            currency = _currency; 
            return true; 
        }

        function notifyChangeOfAddress() external returns (bool _recieved){
            require(isSecure(openAdminRole, "notifyChangeOfAddress")," admin only ");    
            registry                = IOpenRegister(registry.getAddress(registryCA)); // make sure this is NOT a zero address       
            roleManager             = IOpenRoles(registry.getAddress(roleManagerCA));        
            proposalFactory         = IProposalFactory(registry.getAddress(proposalFactoryCA));

            addConfigurationItem(address(registry));   
            addConfigurationItem(address(roleManager));         
            addConfigurationItem(address(proposalFactory));         
            return true; 
        }
        //========================================== INTERNAL =============================================================

        uint256 proposalIndex = 0;  

        function getProposalId() internal returns (uint256 _id){
            _id = proposalIndex; 
            proposalIndex++; 
            return _id; 
        }

        function checkContributor(address _contributor) view internal returns (bool) { 
            require(knownProposal[msg.sender], "unknown proposal");
            IProposal proposal_ = IProposal(msg.sender);
            require(proposal_.isContributor(_contributor)," unknown contributor ");
            return true; 
        }

        function initFunctionsForRoles() internal returns (bool _initiated) {
        
            hasDefaultFunctionsByRole[openAdminRole] = true; 
            defaultFunctionsByRole[openAdminRole].push("notifyChangeOfAddress");

            hasDefaultFunctionsByRole[businessAdminRole] = true; 
            defaultFunctionsByRole[businessAdminRole].push("updateProposalPrice");
            defaultFunctionsByRole[businessAdminRole].push("updateProposalCurrency");

            return true; 
        }

}