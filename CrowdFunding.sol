//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract CrowdFunding
{
    mapping(address=>uint) public contributors;
    address public manager;
    uint public minimumContributions;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

    struct Request
    {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;

    }

    mapping(uint=>Request) public requets;
    uint public numRequests;


    constructor(uint _target,uint _deadline)
    {
        target=_target;
        deadline=block.timestamp+_deadline; //10sec + 3600sec (60* 60)
        minimumContributions=100 wei;
        manager=msg.sender;
    }
    
    function sendEth() public payable
    {
        require(block.timestamp < deadline,"Deadline has passed");
        require(msg.value >= minimumContributions,"Minimum contribution is not met");

        if(contributors[msg.sender]==0)
        {
            noOfContributors++;

        }
        contributors[msg.sender]+=msg.value;
        raisedAmount+=msg.value;

    }

    function getContractBalance() public view returns(uint)
    {
        return address(this).balance;
    }

    function refund() public
    {
        require(block.timestamp>deadline && raisedAmount<target, "You are not eligibility");
        require(contributors[msg.sender]>0);
        address payable user=payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;

    }

    modifier onlyManager()
    {
        require(msg.sender==manager,"ONly Manager can call this function");

    }

    function createRequests(string memory _description,address payable _recipient,uint _value) public onlyManager
    {
        
    }


}