// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract money{

    function sendViaSend(address payable _to, uint amount) public payable {

        bool sent =_to.send(amount);
        require(sent,"failed to send ether");
    }
}