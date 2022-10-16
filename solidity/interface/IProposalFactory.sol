// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
 * @author cryptotwilight 
 */
/** 
 * @title IProposalFactory 
 * This is a background interface for Design Proposal. It is NOT to be called directly 
 */
import { ProposalSeed } from "./IProposal.sol";


interface IProposalFactory { 
    /**
    * @dev
    * @return
    */
    function createProposal(ProposalSeed memory _seed) payable external returns (address _proposal);

}