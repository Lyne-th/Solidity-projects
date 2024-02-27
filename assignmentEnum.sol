// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract lyn{
  uint public Status;

function get() public view returns (uint) {
return Status;
}

function set(uint _Status) public {
    Status = _Status;
}

function cancel() public {
    Status = 4;
}

function reset() public  returns (uint){
return (Status);
}
    
}


