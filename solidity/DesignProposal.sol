// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

import "./IDesignProposal.sol";
import "./Proposal.sol";

contract DesignProposal is IDesignProposal { 
        
        address administrator; 

        address [] proposals; 

        uint256 price; 
        address currency; 

        constructor(address _admin, uint256 _price, address _currency) {
            administrator = _admin; 
            price = _price; 
            currency = _currency; 
        }
        
        function getProposalFee() view external returns (uint256 _price, address _currency){
            return (price, currency);
        }

        function getProposals() view external returns (address [] memory _proposals){
            return proposals; 
        }

        function createProposal(address _owner,
                                string memory _title, 
                                uint256 _targetSubmissionDate, 
                                string memory _backgroundDataLink, 
                                address _currencyAddress, 
                                string [] memory _IPFSpropertyNames, string [] memory _IPFSpropertyValues, 
                                string [] memory _UINTPropertyNames, uint256 [] memory _uintPropertyValues ) payable external returns (address _proposal){
                
            Proposal proposal_ = new Proposal(  getProposalId(),
                                                _owner,
                                                _title, 
                                                _targetSubmissionDate, 
                                                _backgroundDataLink, 
                                                _currencyAddress, 
                                                _IPFSpropertyNames, _IPFSpropertyValues, 
                                                _UINTPropertyNames, _uintPropertyValues );
            _proposal = address(proposal_);                                                    
            proposals.push(_proposal);
            return _proposal;
        }

        //=========================================== INTERNAL ========================================================================

        
        uint256 proposalIndex = 0;  

        function getProposalId() internal returns (uint256 _id){
            _id = proposalIndex; 
            proposalIndex++; 
            return _id; 
        }

}