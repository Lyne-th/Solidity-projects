// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
 
interface IERC20 {
    function transfer(address, uint) external returns (bool);
   //the transfer function is for sending money to the address
    function transferFrom(address, address, uint) external returns (bool);
    //the transfer fron is for sending the money from an address to the owner
}
 
contract CrowdFund {
    //These are the events for Launch, Cancel, Pledge, Unpledge, Claim, Refund functions so
    // the user can interact with them through front-end
    event Launch(
        // This event for Launch function which start a compain for the creator
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
       //This event for Cancel function which cancel a compain
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);
 
    struct Campaign {
        // Creator of campaign
        address creator;
        // Amount of tokens to raise
        uint goal;
        // Total amount pledged
        uint pledged;
        // Timestamp of start of campaign
        uint32 startAt;
        // Timestamp of end of campaign
        uint32 endAt;
        // True if goal was reached and creator has claimed the tokens.
        bool claimed;
    }
 
    IERC20 public immutable token;
    // Total count of campaigns created.
    // It is also used to generate id for new campaigns.
    uint public count;
    // Mapping from id to Campaign
    mapping(uint => Campaign) public campaigns;
    // Mapping from campaign id => pledger => amount pledged
    mapping(uint => mapping(address => uint)) public pledgedAmount;
 
    constructor(address _token) {
       //constructor is set to use ERC token 
        token = IERC20(_token);
    }
 
    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
       //function tp launch a new campaign
        require(_startAt >= block.timestamp, "start at < now");
        // the launch has to start in the future
        require(_endAt >= _startAt, "end at < start at");
        // the endtime has to be grater than the start time.
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");
        // the end time should be in 90 days time.
 
        count += 1;
        // add 1 everytime a new campaign is launched.
        campaigns[count] = Campaign({
            // create a new Campaign and save it in a new campaings mapping.
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
 
        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
        // tells the front end that an event has happened.
    }
 
    function cancel(uint _id) external {
        // to cancel a campaign.
        Campaign memory campaign = campaigns[_id];
        // retrive the particular campaign ID of this Campaign mapping and save it in memory
        require(campaign.creator == msg.sender, "not creator");
        // campaign creator must be the one asking for the campagin to be cancled esle show the error message
        require(block.timestamp < campaign.startAt, "started");
 // this campagin cannot be canceled while the campagin has started.

        delete campaigns[_id];
        //  the campaign ID can be deleted.
        emit Cancel(_id);
        // the frontend should show that the campagin has been canceled.
    }
 
    function pledge(uint _id, uint _amount) external {
        // this function allows a user to pledge for a particular campagin
        Campaign storage campaign = campaigns[_id];
       //retriving Campaign from the mapping campaigns.
        require(block.timestamp >= campaign.startAt, "not started");
        // if the current time is less than the time the campagin is supposed to start, shoe not started
        require(block.timestamp <= campaign.endAt, "ended");
     // if the current time is greater than the end time of the campagin, return ended.

        campaign.pledged += _amount;
       //the amount pledged will be added to the default amount which is 0.
        pledgedAmount[_id][msg.sender] += _amount;
       // storing the informations of a particular amount pledged in a nested mapping called pledgedAmount.
        token.transferFrom(msg.sender, address(this), _amount);
       //to send the amount pledge from the sender to the owner of this particular campaign.

        emit Pledge(_id, msg.sender, _amount);
        // the frontend should show that a pledge has been made.
    }
 
    function unpledge(uint _id, uint _amount) external {
       // allows us to upledge the previous pledge made.
        Campaign storage campaign = campaigns[_id];
       // enables us to retrive the particular campagin from the mapping campagins.
        require(block.timestamp <= campaign.endAt, "ended");
       /*the current time should be less than the time the campagin is supposed to end,
        else return ended.*/

        campaign.pledged -= _amount;
        // subtract the unpleged amount from the previous amount.
        pledgedAmount[_id][msg.sender] -= _amount;
        //updating the amount removed by the sender.
        token.transfer(msg.sender, _amount);
        //transferring the amount back to the sender.
 
        emit Unpledge(_id, msg.sender, _amount);
        //to signify the frontend that an Unpleged action has been carried out.
    }
 
    function claim(uint _id) external {
        //allows the creator to claim a particular campagin
        Campaign storage campaign = campaigns[_id];
        //retriving campagin from the mapping campagins and storing it in Campagin.
        require(campaign.creator == msg.sender, "not creator");
        // the creatorshould be the one allowed to claim ths campagi else return not the creator.
        require(block.timestamp > campaign.endAt, "not ended");
        /* the campagin should be ended for the creator to to carry out function claim,
         else return an error not ended*/
        require(campaign.pledged >= campaign.goal, "pledged < goal");
        /* the amount pledge should be grater than or equal to the goal of the campagin
        else return the erroe pledge< goal*/

        require(!campaign.claimed, "claimed");
        // require that the campagin is unclaimed else return claimed
 
        campaign.claimed = true;
        // once ithe campagin is clamed, return true.
        token.transfer(campaign.creator, campaign.pledged);
        // transfer the pledge to the creator.
 
        emit Claim(_id);
        // signify the frontend that the campagin has been claimed.
    }
 
    function refund(uint _id) external {
        // allows refund of amount pledged. 
        Campaign memory campaign = campaigns[_id];
        // retriving the a particular campagin from the mapping campagins and storing it in the memory Campagin
        require(block.timestamp > campaign.endAt, "not ended");
        /* the campagin should be ended for the creator to to carry out function refunt,
         else return an error not ended*/
        require(campaign.pledged < campaign.goal, "pledged >= goal");
       // amount pledged has to be less than the goal, else return pledge >= goal.

        uint bal = pledgedAmount[_id][msg.sender];
       /* declearing a new variable called balance (how much a particular sender has pledged) 
       which is the amount that was stored.*/

        pledgedAmount[_id][msg.sender] = 0;
        // decreasing the pledgedAmount of a particular sender to 0.

        token.transfer(msg.sender, bal);
        // refunding bal(the amount the sender pledged) to the sender.
        emit Refund(_id, msg.sender, bal);
        //signify the frontend that a refund ahs been made.
    }
}