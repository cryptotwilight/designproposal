// SPDX-License-Identifier: GPL-3.0
// Design Proposal Contracts supported by Protocol Labs Next Step Grant

pragma solidity ^0.8.15;

    struct ProposalSeed { 
        uint256 id; 
        address owner;
        string  title;
        uint256 targetSubmissionDate;
        string  backgroundDataLink;
        address currencyAddress;
        string [] IPFSpropertyNames;
        string [] IPFSpropertyValues; 
        string [] UINTPropertyNames;
        uint256 [] uintPropertyValues;
    }
    
    interface IProposal { 

        function getTitle() view external returns (string memory _title);

        function getTargetSubmissionDate() view external returns (uint256 _date);

        function getOwner()  view external returns (address _owner);

        function getContributors() view external returns (address [] memory _contributors, string [] memory _contributionType);

        function isContributor(address _contributor) view external returns (bool _isContributor);

        function getBackgroundDataLink() view external returns (string memory _link);


        function getStatus() view external returns (string memory _status);


        function getFee(string memory _feeName) view external returns (uint256 _fee);

        function getCurrencyAddress() view external returns (address _currencyAddress);

        
        function getPropertyIPFS(string memory _propertyName) view external returns (string memory _ipfsHash); // image, additional data; 

        function getPropertyUINT(string memory _propertyName) view external returns (uint256 _propertyValue); // vote cycle, vote stake, proposed funding amount

        
        function getSections() view external returns (address[] memory _sections);    
        
        function getProposalResult() view external returns (string memory _result);
        
        function getProposalStatus() view external returns (string memory _status);



        function addSection(string memory _title, string memory _descriptionIpfsHash ) payable external returns (address _sectionAddress);    

        function withdrawProposal() external returns (bool _withdrawn);

        function registerVoter(address _voter) external returns (bool _registered);

    }