// SPDX-License-Identifier: GPL-3.0
// Design Proposal Contracts supported by Protocol Labs Next Step Grant

pragma solidity ^0.8.15;

interface IDesignProposal {


    function getProposalFee() view external returns (uint256 _price, address _currency);
    
    function getProposals() view external returns (address [] memory _proposals);

    function getDaos() view external returns (string [] memory _daos);

    function getProposalsByDAO(string memory _daoName) view external returns (address [] memory _daos);

    function getProposalByOwner(address _owner) view external returns (address [] memory _proposals);

    function getProposalsByContributor(address _contributor) view external returns (address [] memory _proposals);

    function createProposal(string memory _daoName, address _owner,
                            string memory _title, 
                            uint256 _targetSubmissionDate, 
                            string memory _backgroundDataLink, 
                            address _currencyAddress, 
                            string [] memory _IPFSpropertyNames, string [] memory _IPFSpropertyValues, 
                            string [] memory _UINTPropertyNames, uint256 [] memory _uintPropertyValues) payable external returns (address _proposal);
}