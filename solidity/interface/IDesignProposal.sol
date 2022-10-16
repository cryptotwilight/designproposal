// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
 * @author cryptotwilight 
 */
/**
 * @title IDesignProposal 
 * This is the core Design Proposal interface. It is where dependent UIs / DApps integrate. 
 * It provides functions to list DAOs that are contributing to the instance, proposals that have been created, proposal fees. 
 * It also provides functions to create a Proposal returning an address that implements the IProposal interface. 
 * This core interface also provides functions to search for proposals by DAO, owner and contributor
 */
interface IDesignProposal {

    /**
     * @dev This is the fee that will be paid when creating a proposal on the Core Design Proposal contract implementation
     * @return _price raw price to be paid (sans decimals), _currency of the fee to be paid (typically ERC20)
     */
    function getProposalFee() view external returns (uint256 _price, address _currency);
    /**
     * @dev this returns the proposals that have been created on the Core Design Proposal contract implementation
     * @return _proposals unfiltered list of all proposals (implementations of IProposal)
     */
    function getProposals() view external returns (address [] memory _proposals);

    /**
     * @dev this returns a list of all the daos that have been registered on the Core Design Proposal contract implementation
     * @return _daos list of Decentralized Autonomous Organisation (DAO) names 
     */
    function getDaos() view external returns (string [] memory _daos);

    /**
     * @dev this returns a list of all the proposals created under a given DAO
     * @param _daoName name of the DAO 
     * @return _propsals list of proposals for the given DAO (implementations of IProposal)
     */
    function getProposalsByDAO(string memory _daoName) view external returns (address [] memory _propsals);

    /**
     * @dev this returns a list of all the proposals owned by the given address
     * @param _owner address that owns the created proposals
     * @return _proposals list of proposals owned (implementations of IProposal)
     */
    function getProposalByOwner(address _owner) view external returns (address [] memory _proposals);

    /**
     * @dev this returns a list of all the proposals to which a given address has made a contribution
     * @param _contributor address of contributor 
     * @return _proposals which have a contribution from the given address (implementations of IProposal)
     */
    function getProposalsByContributor(address _contributor) view external returns (address [] memory _proposals);

    /**
     * @dev this returns the created proposal based on the give parameters 
     * @param _daoName name of the DAO to which the user is submitting/affilliated
     * @param _owner address of the entity creating the proposal 
     * @param _title title of the proposal 
     * @param _targetSubmissionDate date when the proposal intends to be submitted 
     * @param _backgroundDataLink link to background data on the proposal 
     * @param _currencyAddress currency to be used when making payments to the proposal e.g. for section creation or voting
     * @param _IPFSpropertyNames proposal properties that have been stored on IPFS, PROPOSAL_INFO_IPFS_KEY, PROPOSAL_IMAGE_IPFS_KEY 
     * @param _IPFSpropertyValues values for IPFSPropertyNames
     * @param _uintPropertyNames numeric proposal properties VOTE_CYCLE_TIME_KEY, SECTION_FEE_KEY,  VOTE_FEE_KEY
     * @param _uintPropertyValues values of _uintPropertyNames
     * @return _proposal the proposal created by the given parameters  (implementations of IProposal)
     */
    function createProposal(string memory _daoName, address _owner,
                            string memory _title, 
                            uint256 _targetSubmissionDate, 
                            string memory _backgroundDataLink, 
                            address _currencyAddress, 
                            string [] memory _IPFSpropertyNames, string [] memory _IPFSpropertyValues, 
                            string [] memory _uintPropertyNames, uint256 [] memory _uintPropertyValues) payable external returns (address _proposal);
}