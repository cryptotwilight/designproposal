// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

import "https://github.com/Block-Star-Logic/open-libraries/blob/main/blockchain_ethereum/solidity/V1/libraries/LOpenUtilities.sol";

import "./IProposal.sol";
import "./ISection.sol";
import "./Section.sol";

contract Proposal is IProposal { 

    using LOpenUtilities for string; 
    address self; 
    uint256 id; 
    address owner; 
    string title; 
    uint256 targetSubmissionDate;
    string backgroundDataLink;
    address currencyAddress; 

    string voteCycleTimeKey = "vote_cycle_time_key";
    string voteCostKey = "vote_cost_key";


    mapping(string=>string) ipfsPropertyByName; 
    mapping(string=>uint256) uintPropertyByName; 
    address [] sections; 


    constructor( uint256 _id, 
                address _owner,
                string memory _title, 
                uint256 _targetSubmissionDate, 
                string memory _backgroundDataLink, 
                address _currencyAddress, 
                string [] memory _IPFSpropertyNames, string [] memory _IPFSpropertyValues, 
                string [] memory _UINTPropertyNames, uint256 [] memory _uintPropertyValues ){
        id = _id; 
        self = address(this);
        owner = _owner; 
        title = _title; 
        targetSubmissionDate = _targetSubmissionDate; 
        backgroundDataLink = _backgroundDataLink; 
        currencyAddress = _currencyAddress; 
        for(uint256 x = 0; x < _IPFSpropertyNames.length; x++){
            ipfsPropertyByName[_IPFSpropertyNames[x]] = _IPFSpropertyValues[x];
        }
        for(uint256 y = 0; y < _IPFSpropertyNames.length; y++){
            uintPropertyByName[_UINTPropertyNames[y]] = _uintPropertyValues[y];
        }
    }

    function getTitle() view external returns (string memory _title){
        return title; 
    }

    function getTargetSubmissionDate() view external returns (uint256 _date){
        return targetSubmissionDate; 
    }

    function getOwner()  view external returns (address _owner){
        return owner; 
    }

    function getBackgroundDataLink() view external returns (string memory _link){
        return backgroundDataLink; 
    }

    function getPropertyIPFS(string memory _propertyName) view external returns (string memory _ipfsHash){ // image, additional data; 
        return ipfsPropertyByName[_propertyName];
    }

    function getCurrencyAddress() view external returns (address _currencyAddress){
        return currencyAddress; 
    }

    function getPropertyUINT(string memory _propertyName) view external returns (uint256 _propertyValue){ // vote cycle, vote stake, proposed funding amount
        return uintPropertyByName[_propertyName];
    }

    function getSections() view external returns (address[] memory _sections){
        return sections; 
    }
    
    function getProposalResult() view external returns (string memory _result){
        uint256 acceptedCount = 0; 
        uint256 rejectedCount = 0; 
        for(uint256 x = 0; x < sections.length; x++){
            ISection section_ = ISection(sections[x]);
            string memory result_ = section_.getVoteResult(); 
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
        if(isOpen()){
            return "OPEN";            
        }
        return "CLOSED";
    }

    function addSection(string memory _title, string memory _descriptionIpfsHash ) payable external returns (address _sectionAddress){
        require(isOpen(), " proposal closed ");
        Section section = new Section( getSectionId(),  
                                            self, 
                                            msg.sender, 
                                            _title, 
                                            _descriptionIpfsHash, 
                                            uintPropertyByName[voteCycleTimeKey],
                                            uintPropertyByName[voteCostKey]);
        _sectionAddress = address(section);
        sections.push(address(_sectionAddress));
        return _sectionAddress;         
    }


    //========================================= INTERNAL ============================================================================

    uint256 sectionIndex = 0;  

    function getSectionId() internal returns (uint256 _id){
        _id = sectionIndex; 
        sectionIndex++; 
        return _id; 
    }

    function isOpen() view internal returns (bool ){
        if(block.timestamp > targetSubmissionDate) {
            return false; 
        }
        return true; 
    }

}