// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

interface ISection { 

    struct Vote{
        bool vote; 
        address voter; 
        string commentIpfsHash; 
        uint256 stakedAmount;       
        uint256 voteTime; 
    }

    function getProposal() view external returns (address _proposal);

    function getSectionId() view external returns (uint256 _id);

    function getAuthor() view external returns (address _author);

    function getStatus() view external returns (string memory _status);

    function getContent() view external returns (string memory _ipfsHash);

    function getCycleTimeRemaining() view external returns (uint256 _time);

    function getVoteCost() view external returns (uint256 _cost);

    function getVoteResult() view external returns (string memory _voteResult);

    function getVotes() view external returns (Vote [] memory _votes);

    function vote(bool upVote, string memory _ipfsHash) payable external returns (bool _voted);
    
}