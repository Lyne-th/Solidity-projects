// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract RecieveEther{

    receive() external payable { }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}

contract SendEther{
    receive() external payable { }

    function sendViaTransfer(address payable _to, uint amount) public payable{
        _to.transfer(amount);
    }
}