// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
 * @author cryptotwilight
 */
/**
* @title ISection 
* The Section is where voting takes place for the proposal. The result of the Proposal is determined by the support garnered through out the Sections associated with the Proposal 
*/
interface ISection { 
    /**
    * @dev the Vote is a representation of a contributor's vote on a given section of a proposal. Each Vote has an associated comment from the Voter    
    */
    struct Vote{
        
        /** 
         * @dev whether the voter supports the section or not
         */
        bool upVote;  
        
        /** 
         * @dev the address of the voter 
         */
        address voter;  
        
        /** 
         * @dev the IPFS content address for the comment 
         */
        string commentIpfsHash; 
        
        /** 
         * @dev the amount paid by the voter to vote 
         */
        uint256 amountPaid;       
        
        /** 
         * @dev the time at which the vote was cast 
         */
        uint256 voteTime; 
    }

    /**
    * @dev this returns the address of the Proposal to which this section is tied
    * @return _proposal address of owning Proposal (implementation of IProposal) 
    */
    function getProposal() view external returns (address _proposal);
    
    /**
    * @dev this returns the id of this section within the owning proposal 
    * @return _id of section 
    */
    function getSectionId() view external returns (uint256 _id);
    
    /**
    * @dev this returns the title of the Section 
    * @return _title of the Section 
    */
    function getTitle() view external returns (string memory _title); 
    
    /**
    * @dev this returns the originator of this Section 
    * @return _originator address of entity that created this section 
    */
    function getOriginator() view external returns (address _originator);    
    
    /**
    * @dev this returns the status of this Section 
    * @return _status status of the Section "WITHDRAWN", "OPEN", "CLOSED"
    */
    function getStatus() view external returns (string memory _status);
    
    /**
    * @dev this returns the IPFS content address to the data for this section 
    * @return _ipfsHash IPFS content address for content for this section 
    */
    function getContent() view external returns (string memory _ipfsHash);
    
    /**
    * @dev this returns the amount of time remaining for voters to cast their votes 
    * @return _time block time till end of cycle time (in seconds) 
    */
    function getCycleTimeRemaining() view external returns (uint256 _time);
    
    /**
    * @dev this returns the result of the votes on this section 
    * @return _voteResult of the votes cast on this Section "STILL_VOTING","ACCEPTED","REJECTED"
    */
    function getVoteResult() view external returns (string memory _voteResult);
    
    /**
    * @dev this returns all the votes that were cast for this Section 
    * @return _votes cast for this Section 
    */
    function getVotes() view external returns (Vote [] memory _votes);
    
    /**
    * @dev this enables the voters to vote and comment 
    * @param _upVote true if the voter supports the section 
    * @param _ipfsHash IPFS content address to voter comment 
    * @return _voted true if the vote has been successfully cast 
    */
    function vote(bool _upVote, string memory _ipfsHash) payable external returns (bool _voted);

    /**
    * @dev this withdraws the section from the proposal, disabling all voting 
    * @return _withdrawn true if all withdrawal operations successfully executed
    */
    function withdrawSection() external returns (bool _withdrawn); 
}