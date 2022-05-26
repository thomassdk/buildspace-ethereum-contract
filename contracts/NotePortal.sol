// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract NotePortal {
    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;

    event NewNote(address indexed from, uint256 timestamp, string message);

    struct Note {
        address player;
        string note;
        uint256 timestamp;
    }

    Note[] notes;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user played a note.
     */
    mapping(address => uint256) public lastNotePlayedAt;

    constructor() payable {
        console.log("We have been constructed!");
        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function playNote(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Must wait 30 seconds before playing another note.");

        /*
         * Update the current timestamp we have for the user
         */
        lastNotePlayedAt[msg.sender] = block.timestamp;

        console.log("%s has played!", msg.sender);

        notes.push(Note(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a note
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewNote(msg.sender, block.timestamp, _message);
    }

    function getAllNotes() public view returns (Note[] memory) {
        return notes;
    }

    function getTotalNotes() public view returns (uint256) {
        return notes.length;
    }
}
