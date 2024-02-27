// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract PaybleContract{

    address  payable public  owner;

    constructor() public {
        owner = payable (msg.sender);
    }

    function deposit() public {

    }
     function receive() external payable { }

    function getbalance() public returns (uint){
        return address(this).balance;
    }
}