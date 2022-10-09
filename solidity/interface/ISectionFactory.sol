// SPDX-License-Identifier: GPL-3.0
// Design Proposal Contracts supported by Protocol Labs Next Step Grant

pragma solidity ^0.8.15;


interface ISectionFactory { 


    function createSection(uint256 _id, 
                            address _proposal, 
                            address _originator, 
                            string memory _title, 
                            string memory _contentIpfsHash, 
                            uint256 _voteCycleTime) external returns (address _section);

}