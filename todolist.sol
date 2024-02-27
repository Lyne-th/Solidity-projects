// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Todo{
    struct micro {
        string title;
        bool completed;
    }
        micro[] public tech;

    function Insert (string memory newTitle) public{
        tech.push(micro(newTitle, false));
    }

    function update(uint index, string memory newTitle) public {
tech[index].title = newTitle;
//concatination
    }

    function status(uint index) public {
        tech[index].completed = true;
    }
}