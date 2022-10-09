// SPDX-License-Identifier: GPL-3.0
// Design Proposal Contracts supported by Protocol Labs Next Step Grant

pragma solidity ^0.8.15;

interface IDPManagement { 

    function registerContributor(address _contributor) external returns (bool _registered);

    function deregisterContributor(address _contributor) external returns (bool _deregistered);
}