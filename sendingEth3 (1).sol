// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Money{

   function sendViaCall(address payable _to, uint amount) public payable  {

 (bool sent, bytes memory data) = _to.call{value:amount}("");
   }
   require (sent, "failed to send ether");


}