// SPDX-License-Identifier: GPL-3.0
// Design Proposal Contracts supported by Protocol Labs Next Step Grant

pragma solidity ^0.8.17;

import "../interface/IProposal.sol";
import "../interface/ISection.sol";

contract Section is ISection { 

    IProposal proposal; 

    string constant voteFeeKey = "VOTE_FEE_KEY";

    uint256 voteCycleTime; 
    string contentIpfsHash; 
    uint256 startTime;         
    uint256 id; 
    address originator; 
    string title; 

    bool withdrawn; 

    uint256 votesFor     = 0; 
    uint256 votesAgainst = 0; 

    address [] voters; 
    mapping(address=>bool) knownVoter; 

    mapping(address=>Vote) voteByVoter; 

    constructor(    
                    uint256 _id, 
                    address _proposal, 
                    address _originator, 
                    string memory _title, 
                    string memory _contentIpfsHash, 
                    uint256 _voteCycleTime
                ) {
        title = _title; 
        startTime = block.timestamp; 
        voteCycleTime = _voteCycleTime; 
        contentIpfsHash = _contentIpfsHash; 

        proposal = IProposal(_proposal); 
        id = _id;
        originator = _originator; 
    }

    function getProposal() view external returns (address _proposal){
        return address(proposal);
    }

    function getSectionId() view external returns (uint256 _id){
        return id; 
    }

    function getOriginator() view external returns (address _originator){
        return originator; 
    }

    function getStatus() view external returns (string memory _status){
        if(withdrawn) {
            return "WITHDRAWN";
        }
        if(isOpen()){
            return "OPEN";
        }
        return "CLOSED"; 
    }

    function getContent() view external returns (string memory _ipfsHash){
        return contentIpfsHash; 
    }

    function getCycleTimeRemaining() view external returns (uint256 _time){
        uint256 end_ = startTime + voteCycleTime; 
        if(block.timestamp > end_) {
            return 0; 
        }
        return end_ - block.timestamp; 
    }

    function getVoteResult() view external returns (string memory _voteResult){
        if(isOpen()) {
            return "STILL_VOTING";
        }
        if(withdrawn) {
            return "WITHDRAWN";
        }
        if(votesFor > votesAgainst) {
            return "ACCEPTED";
        }
        return "REJECTED";
        
    }

    function getVotes() view external returns (Vote [] memory _votes){
        _votes = new Vote[](voters.length);
        for(uint256 x = 0; x < voters.length; x++) {
            _votes[x] = voteByVoter[voters[x]];
        }
        return _votes; 
    }

    function vote(bool _upVote, string memory _ipfsHash) payable external returns (bool _voted){
        require(isOpen(), " section closed ");
        require(!knownVoter[msg.sender], " already voted ");
        
        knownVoter[msg.sender] = true; 
        proposal.registerVoter(msg.sender);

        if(_upVote) {
            votesFor++;
        }
        else { 
            votesAgainst++;
        }
        voters.push(msg.sender);
        
        Vote memory vote_ = Vote({      
                                    upVote          : _upVote,                    
                                    voter           : msg.sender, 
                                    commentIpfsHash : _ipfsHash, 
                                    amountPaid      : proposal.getFee(voteFeeKey),       
                                    voteTime        : block.timestamp
                                });
        voteByVoter[msg.sender] = vote_; 
        return true; 
    }

    function withdrawSection() external returns (bool _withdrawn){
        require(isOpen() && (msg.sender == originator || msg.sender == address(proposal)), "section closed");
        withdrawn = true; 
        return true; 
    }

    //================================== INTERNAL ===============================================================

    function isOpen() view internal returns (bool) {
        if(withdrawn) {
            return false; 
        }
        uint256 end_ = startTime + voteCycleTime; 
        if(block.timestamp > end_) {
            return false; 
        }
        return true; 
    }
}