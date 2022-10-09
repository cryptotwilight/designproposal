// SPDX-License-Identifier: GPL-3.0
// Design Proposal Contracts supported by Protocol Labs Next Step Grant

pragma solidity ^0.8.15;

interface ISection { 

    struct Vote{
        bool upVote; 
        address voter; 
        string commentIpfsHash; 
        uint256 amountPaid;       
        uint256 voteTime; 
    }

    

    function getProposal() view external returns (address _proposal);

    function getSectionId() view external returns (uint256 _id);

    function getOriginator() view external returns (address _author);

    function getStatus() view external returns (string memory _status);

    function getContent() view external returns (string memory _ipfsHash);

    function getCycleTimeRemaining() view external returns (uint256 _time);

    function getVoteResult() view external returns (string memory _voteResult);

    function getVotes() view external returns (Vote [] memory _votes);

    function vote(bool _upVote, string memory _ipfsHash) payable external returns (bool _voted);
    
    function withdrawSection() external returns (bool _withdrawn); 
}