// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract elechi{

    address public owner;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "you are not the ownwer bighead");
        _;
    }

    function setOwner(address _newOwner) public  onlyOwner{
        require(_newOwner != address(0) , "invalid address");
    }

    function onlyownercancall() public onlyOwner{

    }

    function anyonecancall() public {
        
    }
}

