// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
  * @author cryptotwilight 
  */
import "https://github.com/Block-Star-Logic/open-libraries/blob/703b21257790c56a61cd0f3d9de3187a9012e2b3/blockchain_ethereum/solidity/V1/libraries/LOpenUtilities.sol";

import "https://github.com/Block-Star-Logic/open-register/blob/0959ffa2af2ca2cb3e5dd0f7b495e831cca2d506/blockchain_ethereum/solidity/V1/interfaces/IOpenRegister.sol";

import "https://github.com/Block-Star-Logic/open-version/blob/e161e8a2133fbeae14c45f1c3985c0a60f9a0e54/blockchain_ethereum/solidity/V1/interfaces/IOpenVersion.sol";

import "../interface/IProposal.sol";
import "../interface/ISection.sol";
import "../interface/ISectionFactory.sol";
import "../interface/IDPManagement.sol";

/**
 * @dev IProposal impelementation 
 */

contract Proposal is IProposal, IOpenVersion { 

    using LOpenUtilities for string; 

    string constant name                = "PROPOSAL";
    uint256 constant version            = 7;  

    string constant sectionFactoryCA    = "RESERVED_DESIGN_PROPOSAL_SECTION_FACTORY_CORE";

    IOpenRegister registry;  
    ProposalSeed seed; 
    address self; 
    address currencyAddress; 
    
    string status; 
    bool withdrawn; 

    string constant designProposalCA    = "RESERVED_DESIGN_PROPOSAL_CORE";

    string constant voteCycleTimeKey    = "VOTE_CYCLE_TIME_KEY";

    string constant voteFeeKey          = "VOTE_FEE_KEY";
    string constant sectionFeeKey       = "SECTION_FEE_KEY";

    mapping(string=>string) ipfsPropertyByName; 
    mapping(string=>uint256) uintPropertyByName; 

    address [] contributors; 
    uint256 contributionCount; 
    mapping(address=>bool) knownContributor; 
    mapping(address=>string[]) contributionTypesByContributor;
    
    mapping(address=>bool) knownSectionContributor;

    address [] voters; 
    mapping(address=>bool) knownVoters; 


    address [] sections; 
    mapping(address=>bool) knownSections; 

    constructor(address _registry, ProposalSeed memory _seed){   
        registry = IOpenRegister(_registry);   
        seed = _seed; 
        self = address(this);
        currencyAddress =  _seed.currencyAddress;      
        for(uint256 x = 0; x < _seed.IPFSpropertyNames.length; x++){
            ipfsPropertyByName[_seed.IPFSpropertyNames[x]] = _seed.IPFSpropertyValues[x];
        }
        for(uint256 y = 0; y < _seed.uintPropertyNames.length; y++){
            uintPropertyByName[_seed.uintPropertyNames[y]] = _seed.uintPropertyValues[y];
        }
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getTitle() view external returns (string memory _title){
        return seed.title; 
    }

    function getTargetSubmissionDate() view external returns (uint256 _date){
        return seed.targetSubmissionDate; 
    }

    function getOwner()  view external returns (address _owner){
        return seed.owner; 
    }

    function getBackgroundDataLink() view external returns (string memory _link){
        return seed.backgroundDataLink; 
    }

    function getStatus() view external returns (string memory _status) {
        if(isOpen()){
            return "OPEN";
        }
        if(withdrawn) {
            return "WITHDRAWN";
        }
        return "CLOSED"; 
    }

    function getFee(string memory _name) view external returns (uint256 _fee) {
        return uintPropertyByName[_name];
    }

    function getPropertyIPFS(string memory _propertyName) view external returns (string memory _ipfsHash){ // PROPOSAL_INFO_IPFS_KEY, PROPOSAL_IMAGE_IPFS_KEY
        return ipfsPropertyByName[_propertyName];
    }

    function getCurrencyAddress() view external returns (address _currencyAddress){
        return currencyAddress; 
    }

    function getPropertyUINT(string memory _propertyName) view external returns (uint256 _propertyValue){ // 
        return uintPropertyByName[_propertyName];
    }

    function getSections() view external returns (address[] memory _sections){
        return sections; 
    }

    function getContributors() view external returns (address [] memory _contributors, string [] memory _contributionTypes){
        _contributionTypes  = new string[](contributionCount);
        uint256 y = 0; 
        for(uint256 x = 0; x < contributors.length; x++){
            address contributor_ = contributors[x];
            string [] memory types_ = contributionTypesByContributor[contributor_];
            for(uint256 z = 0; z < types_.length; z++){
                _contributionTypes[y] = types_[z];
                y++;
            }        
        }
        return (contributors, _contributionTypes);
    }

    function isContributor(address _contributor) view external returns (bool _isContributor){
        return knownContributor[_contributor];
    }

    function getProposalResult() view external returns (string memory _result){
        uint256 acceptedCount = 0; 
        uint256 rejectedCount = 0; 
        for(uint256 x = 0; x < sections.length; x++){
            ISection section_ = ISection(sections[x]);
            string memory result_ = section_.getVoteResult(); 
            if(result_.isEqual("STILL_VOTING")) {
                return "STILL_VOTING";
            }
            if(result_.isEqual("WITHDRAWN")){
                continue;
            }
            if(result_.isEqual("ACCEPTED")) {
                acceptedCount++;
            }
            else { 
                rejectedCount++;
            }
        }

        if(acceptedCount > rejectedCount) { 
            _result = "ACCEPTED";
        }
        else { 
            _result = "REJECTED";
        }
        return _result; 
    }

    function getProposalStatus() view external returns (string memory _status){
        if(withdrawn) {
            return "WITHDRAWN";
        }
        if(isOpen()){
            return "OPEN";            
        }
        return "CLOSED";
    }

    function addSection(string memory _title, string memory _descriptionIpfsHash ) payable external returns (address _sectionAddress){
        require(isOpen(), " proposal closed ");
        _sectionAddress = getSectionFactory().createSection( getSectionId(),  
                                                            self, 
                                                            msg.sender, 
                                                            _title, 
                                                            _descriptionIpfsHash, 
                                                            uintPropertyByName[voteCycleTimeKey]);
        knownSections[_sectionAddress] = true;
        sections.push(address(_sectionAddress));
        registerContribution(msg.sender, "SECTION_CONTRIBUTION");        
        return _sectionAddress;         
    }
    
    function registerVoter(address _voter) external returns (bool _registered) {
        require(knownSections[msg.sender], " unknown section ");
        return registerContribution(_voter, "VOTE_CONTRIBUTION");
    }

    function withdrawProposal() external returns (bool _withdrawn){
        if(isOpen()) {
            // refund all sections 
            for(uint256 x = 0; x < sections.length; x++) {
                ISection section_ = ISection(sections[x]);
                section_.withdrawSection();
            }
            withdrawn = true; 
        }
        return true; 
    }

    function setFee(string memory _feeName, uint256 _fee) external returns (bool _set) {
        require(seed.owner == msg.sender, " owner only ");
        uintPropertyByName[_feeName] = _fee; 
        return true; 
    }

    //========================================= INTERNAL ============================================================================

    uint256 sectionIndex = 0;  

    function getSectionId() internal returns (uint256 _id){
        _id = sectionIndex; 
        sectionIndex++; 
        return _id; 
    }

    function isOpen() view internal returns (bool ){
        if(withdrawn) {
            return false; 
        }
        if(block.timestamp > seed.targetSubmissionDate) {
            return false; 
        }
        return true; 
    }

    function getSectionFactory() view internal returns (ISectionFactory _factory) {
        return ISectionFactory(registry.getAddress(sectionFactoryCA));
    }

    function getDesignProposal() view internal returns (IDPManagement _designProposal) {
        return IDPManagement(registry.getAddress(designProposalCA));
    }

    function registerContribution(address _contributor, string memory _contributionType) internal returns (bool _registered){
        if(!knownContributor[_contributor]) {
            knownContributor[_contributor] = true;             
            getDesignProposal().registerContributor(_contributor);
        }
        
        if(_contributionType.isEqual("VOTE_CONTRIBUTION") && !knownVoters[_contributor]) {
            contributionTypesByContributor[_contributor].push("VOTE_CONTRIBUTION");
            knownVoters[_contributor] = true; 
            return true; 
        }
        if(_contributionType.isEqual("SECTION_CONTRIBUTION") && !knownSectionContributor[_contributor]){
            contributionTypesByContributor[_contributor].push("VOTE_CONTRIBUTION");
            knownSectionContributor[_contributor] = true; 
            return true; 
        }        
        return false; 
    }

}