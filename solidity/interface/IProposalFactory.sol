// SPDX-License-Identifier: GPL-3.0
// Design Proposal Contracts supported by Protocol Labs Next Step Grant

pragma solidity ^0.8.17;

import { ProposalSeed } from "./IProposal.sol";

interface IProposalFactory { 

    function createProposal(ProposalSeed memory _seed) payable external returns (address _proposal);

}