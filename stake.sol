// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 // importing ERC20 codes from openzappelin library
contract MyToken is ERC20 {
    // Creating my contract MyToken that inherits ERC20 token
 
mapping(address => uint) public staked;
/* creating a mapping for the person who wants to stake 
(the address of the person=> howmuch will be staking*/
mapping(address => uint) private stakedFromTS;
// a new mapping 
 
    constructor() ERC20("MyToken", "MTK") {
        //constructor is set to initialize MyToken
        _mint(msg.sender, 1000);
        // mintiong 1000 by default
    }
 
function stake(uint amount) external{
    // function to launch stake
require(amount >0, "amount is <=0");
// amount should be greater than 0 else return an error message "amount is <=0"
require(balanceOf(msg.sender) >= amount, "balance is <= amount");
/* the balance of the sender should be greater or equal to amount,
else show an errorr message "balance is <= amount"*/
_transfer(msg.sender, address(this), amount);
// transferring an amount from the sender to the address of the contract
 
if(staked[msg.sender] > 0){
claim();
// If the amount staked is greater than 0, then claim the amount
}
stakedFromTS[msg.sender] = block.timestamp;
// saving the time the amount will be staked.
staked[msg.sender] += amount;
// adding the staked amount to the staked amount in the mapping staked
 
}
 
function unstake(uint amount) external{
    // creating a function to unstake
require(amount >0, "amount is <=0");
// the amount to unstake should be greater than 0 else give an error message"amount is <0"
require(staked[msg.sender] > 0, "You did not stake with us");
/*the amount staked by the sender should be greater than 0 else return an reeor messgae 
"you did not stake with us " */
stakedFromTS[msg.sender] = block.timestamp;
//
staked[msg.sender] -= amount;
// subtracting the amount staked from the staked amount
_transfer(address(this), msg.sender, amount);
// transferrin the amount from the address of the contract to the sender
}
 
function claim() public {
    // creating a function to claim
require(staked[msg.sender] > 0, "Staked is <= 0 ");
// the staked amount should be greater than 0, give an error statement "staked is less than 0"
uint secondsStaked = block.timestamp - stakedFromTS[msg.sender];
//Declaring new variable called secondsStaked for saving the duration of staking.
uint rewards = staked[msg.sender] * secondsStaked / 3.154e7;
/*Declaring new variable called rewards for calculating the amount gained after staking for a particular person.
We then calculate the rewards by multiplying the amount staked by the seconds staked
and dividing by the number of seconds in a year (3.154e7 = seven decimals = 31,540,000).*/
_mint(msg.sender, rewards);
//Minting the gained amount.
stakedFromTS[msg.sender] = block.timestamp;
//Saving the time when the amount will be claimed in stakedFromTS mapping.
 
}
   
}