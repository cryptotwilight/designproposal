// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.17;
/** 
 * @author cryptotwilight 
 */
/** 
 * @title ISectionFactory 
 * This is a background interface for Design Proposal. It is NOT to be called directly 
 */
interface ISectionFactory { 

    /**
    * @dev
    * @return 
    */
    function createSection(uint256 _id, 
                            address _proposal, 
                            address _originator, 
                            string memory _title, 
                            string memory _contentIpfsHash, 
                            uint256 _voteCycleTime) external returns (address _section);

}