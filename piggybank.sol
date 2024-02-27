// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Piggybank{

    event deposit(uint amount);
    event Withdraw(uint amount);
address public owner = msg.sender;

receive() external payable {
    emit  deposit(msg.value);
 }

function takefunds() public{
require(msg.sender == owner, "you are not the owner"); //to check the amount you have
emit Withdraw(address(this).balance);
selfdestruct (payable (msg.sender));


}
}