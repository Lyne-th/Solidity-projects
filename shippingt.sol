// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShippingGoods{
    enum Ship{
        pending,
        Shipped,
        Aceppted,
        Rejected,
        Cancelled
    }

    Ship public Dress;

    function get() public view returns (Ship){
        return(Dress);
    }
function set(Ship _x) public {
    Dress = _x;
}

function Shipped() public {
    Dress = Ship.Shipped;
}

function Aceppted() public {
    Dress = Ship.Aceppted;
}

function Rejected() public {
    Dress = Ship.Rejected;
}
}