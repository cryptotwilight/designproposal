// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;


interface IProposal { 

    function getTitle() view external returns (string memory _title);

    function getTargetSubmissionDate() view external returns (uint256 _date);

    function getOwner()  view external returns (address _owner);

    function getBackgroundDataLink() view external returns (string memory _link);

    function getPropertyIPFS(string memory _propertyName) view external returns (string memory _ipfsHash); // image, additional data; 

    function getCurrencyAddress() view external returns (address _currencyAddress);

    function getPropertyUINT(string memory _propertyName) view external returns (uint256 _propertyValue); // vote cycle, vote stake, proposed funding amount

    function getSections() view external returns (address[] memory _sections);    
    
    function addSection(string memory _title, string memory _descriptionIpfsHash ) payable external returns (address _sectionAddress);

    function getProposalResult() view external returns (string memory _result);

    function getProposalStatus() view external returns (string memory _status);

}