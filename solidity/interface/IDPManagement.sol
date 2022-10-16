// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
 * @author cryptotwilight 
 */
/**
 * @title IDPManagement 
 * This is a background interface for Design Proposal. It is NOT to be called directly 
 */
interface IDPManagement { 
    /**
    * @dev
    * @return
    */
    function registerContributor(address _contributor) external returns (bool _registered);
    /**
    * @dev
    * @return
    */
    function deregisterContributor(address _contributor) external returns (bool _deregistered);
}