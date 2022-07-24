// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

import "./ISection.sol";

contract Section is ISection { 

    uint256 voteCycleTime; 
    string contentIpfsHash; 
    uint256 startTime; 
    uint256 voteCost; 
    address proposal; 
    uint256 id; 
    address author; 
    string title; 

    uint256 votesFor = 0; 
    uint256 votesAgainst = 0; 

    address [] voters; 

    mapping(address=>Vote) voteByVoter; 

    constructor( uint256 _id, 
                address _proposal, 
                address _author, 
                string memory _title, 
                string memory _contentIpfsHash, 
                uint256 _voteCycleTime,
                uint256 _voteCost ) {
        title = _title; 
        startTime = block.timestamp; 
        voteCycleTime = _voteCycleTime; 
        contentIpfsHash = _contentIpfsHash; 
        voteCost = _voteCost; 
        proposal = _proposal; 
        id = _id;
        author = _author; 

    }

    function getProposal() view external returns (address _proposal){
        return proposal;
    }

    function getSectionId() view external returns (uint256 _id){
        return id; 
    }

    function getAuthor() view external returns (address _author){
        return author; 
    }

    function getStatus() view external returns (string memory _status){
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

    function getVoteCost() view external returns (uint256 _cost){
        return voteCost; 
    }

    function getVoteResult() view external returns (string memory _voteResult){
        if(isOpen()) {
            return "STILL_VOTING";
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
        if(_upVote) {
            votesFor++;
        }
        else { 
            votesAgainst++;
        }
        voters.push(msg.sender);
        Vote memory vote_ = Vote({      
                            vote : _upVote,                    
                            voter : msg.sender, 
                            commentIpfsHash : _ipfsHash, 
                            stakedAmount : msg.value,       
                            voteTime :block.timestamp
                        });
        voteByVoter[msg.sender] = vote_; 
        return true; 
    }


    //================================== INTERNAL ===============================================================

    function isOpen() view internal returns (bool) {
        uint256 end_ = startTime + voteCycleTime; 
        if(block.timestamp > end_) {
            return false; 
        }
        return true; 
    }


}