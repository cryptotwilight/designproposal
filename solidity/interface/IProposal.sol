// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
 * @author cryptotwilight 
 */

/**
* @dev ProposalSeed this struct represents the source data for the Proposal Contract that is to be created. 
*/
struct ProposalSeed { 

    /** 
     * @dev id for the ProposalSeed which should become the Id of the IProposal implementation  
     */
    uint256 id;

    /** 
     * @dev address of the entity creating the proposal 
     */
    address owner; 

    /** 
      * @dev title of the proposal  
      */
    string  title; 

    /** 
      * @dev date when the proposal intends to be submitted  
      */
    uint256 targetSubmissionDate; 

    /** 
      * @dev link to background data on the proposal  
      */
    string  backgroundDataLink; 

    /** 
     * @dev currency to be used when making payments to the proposal e.g. for section creation or voting 
     */
    address currencyAddress; 

    /** 
     * @dev  properties that have been stored on IPFS, PROPOSAL_INFO_IPFS_KEY, PROPOSAL_IMAGE_IPFS_KEY 
     */
    string [] IPFSpropertyNames; 

     /** 
      * @dev values for IPFSPropertyNames 
      */
    string [] IPFSpropertyValues; 

     /** 
      * @dev numeric proposal properties VOTE_CYCLE_TIME_KEY, SECTION_FEE_KEY,  VOTE_FEE_KEY 
      */
    string [] uintPropertyNames;

    /** 
     * @dev values of _uintPropertyNames 
     */
    uint256 [] uintPropertyValues; 
}

/**
* @title IProposal 
* @dev the IProposal interface represents the Proposals that are to be created and voted on when using Design Proposal. Each proposal is represented as an atomic on chain contract that has multiple sections. 
* Each section is contributed by a single individual the goal being to ensure that the views of the community in a given DAO are reflected. 
*/
interface IProposal { 
    
    /**
    * @dev this returns the title of the proposal 
    * @return _title of the proposal 
    */
    function getTitle() view external returns (string memory _title);
    
    /**
    * @dev this returns the date when this proposal is to be submitted, this also represents the day that this Proposal is closed
    * @return _date Proposal is to be submitted 
    */
    function getTargetSubmissionDate() view external returns (uint256 _date);
    
    /**
    * @dev this represents the address of the owner of this proposal 
    * @return _owner of Proposal 
    */
    function getOwner()  view external returns (address _owner);
    
    /**
    * @dev this returns the contributors to this proposal and the type of contribution made 
    * @return _contributors the contributors to this proposal, _contributionType the type of the contributor 
    */
    function getContributors() view external returns (address [] memory _contributors, string [] memory _contributionType);
    
    /**        
    * @dev this identifies whether a given address is a contributor to this proposal 
    * @param _contributor address of "would be" contributor 
    * @return _isContributor true if the given contributor is a contributor to this Proposal 
    */
    function isContributor(address _contributor) view external returns (bool _isContributor);

    /**
    * @dev this returns a link to background data on this Proposal 
    * @return _link to background data 
    */
    function getBackgroundDataLink() view external returns (string memory _link);

    /**
    * @dev this returns the status of the Proposal 
    * @return _status of this Proposal "OPEN", "CLOSED", "WITHDRAWN"
    */
    function getStatus() view external returns (string memory _status);

    /**
    * @dev this returns the given fee value sans decimals for the given key 
    * @param _feeName name of the fee required "SECTION_FEE_KEY", "VOTE_FEE_KEY"
    * @return _fee for the given feeName 
    */
    function getFee(string memory _feeName) view external returns (uint256 _fee); 

    /**
    * @dev this returns the address for the currency used for payments for this Proposal. 
    * @return _currencyAddress for payments to this proposal 
    */
    function getCurrencyAddress() view external returns (address _currencyAddress);

    /**
    * @dev this returns the IPFS content address for the propertyName provided 
    * @param _propertyName name of property that has content stored on IPFS "PROPOSAL_INFO_IPFS_KEY", "PROPOSAL_IMAGE_IPFS_KEY"
    * @return _ipfsHash IPFS content address 
    */        
    function getPropertyIPFS(string memory _propertyName) view external returns (string memory _ipfsHash); 

    /**
    * @dev this returns the numeric value for the given propertyName
    * @param _propertyName name of numeric property          
    * @return _propertyValue value for property "VOTE_CYCLE_TIME_KEY", "SECTION_FEE_KEY", "VOTE_FEE_KEY" 
    */
    function getPropertyUINT(string memory _propertyName) view external returns (uint256 _propertyValue); 

    /**
    * @dev this returns the sections that are attached to then proposal (implementations of ISection) 
    * @return _sections sections for this proposal 
    */
    function getSections() view external returns (address[] memory _sections);    
    
    /**
    * @dev this returns the combined result for this proposal 
    * @return _result the result of the Proposal "STILL_VOTING", "ACCEPTED", "REJECTED"
    */
    function getProposalResult() view external returns (string memory _result);
    
    /**
    * @dev this returns the status of this proposal 
    * @return _status the status of this proposal "OPEN", "CLOSED", "WITHDRAWN"
    */       
    function getProposalStatus() view external returns (string memory _status);

    /**
    * @dev this adds a section to the proposal and returns a section contract that enables voting on the section (implementation of ISection) 
    * @param _title of the section 
    * @param _descriptionIpfsHash IPFS content address where section body is located        
    * @return _sectionAddress voting contract for the added section (implementation of ISection) 
    */
    function addSection(string memory _title, string memory _descriptionIpfsHash ) payable external returns (address _sectionAddress);    
    
    /**
    * @dev this withdraws the Proposal from consideration. It effectively shutsdown the proposal prior to the submission date.     
    * @return _withdrawn true once all Withdrawal operations have been completed 
    */
    function withdrawProposal() external returns (bool _withdrawn);
    /**
    * @dev this operation registers voters with the Proposal 
    * @param _voter address         
    * @return _registered true if the voter is registered
    */
    function registerVoter(address _voter) external returns (bool _registered);

}