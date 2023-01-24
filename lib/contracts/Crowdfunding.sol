// SPDX-License-Identifier: UNLICENSD
pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding{
    address public owner;
    string public eventName;
    uint public amountRequired;
    uint public minDonation;
    mapping (address => uint) public donations;
    uint public totalDonars = 0;
    uint public fundRaised = 0;
    uint public deadline;
    struct SpendDescription {
        uint required;
        address recipient;
        bool closed;
        uint votes;
        mapping (address => bool) voterDonars;
        string desc;
    }
    SpendDescription [] public spendRequests;

    modifier isOwner {
        require(msg.sender == owner);
        _;
    }

    modifier req_amt_Raised{
        require(fundRaised >= amountRequired);
        _;
    }

    modifier userDonated {
        require(donations[msg.sender] > 0);
        _;
    }

    modifier deadlineReached {
        require(block.number > deadline);
        _;
    }

    modifier donationEligible {
        require(minDonation <= msg.value);
        _;
    }

    function registerEvent(string memory _eventName) public {
        owner = msg.sender;
        eventName = _eventName;
    }

    function setData(uint _amountRequired, uint _minDonation, uint _deadline) public isOwner{
        amountRequired = _amountRequired;
        minDonation = _minDonation;
        deadline = block.number + _deadline;
    }

    function donate() payable public donationEligible {
        if(donations[msg.sender] == 0){
            totalDonars ++;
        }
        fundRaised += msg.value;
        donations[msg.sender] += msg.value;
    }

    function request_to_spend(uint _required, address _recipient, string memory _desc) public isOwner req_amt_Raised {
        
        SpendDescription storage SpendingRequest =  spendRequests.push();

        
        SpendingRequest.required = _required;
        SpendingRequest.recipient = _recipient;
        SpendingRequest.closed = false;
        SpendingRequest.votes = 0;
        SpendingRequest.desc = _desc;
        // SpendDescription memory SpendingRequest = SpendDescription({
        //     required: _required,
        //     recipient: _recipient,
        //     closed: false,
        //     votes: 0,
        //     desc: _desc
        // });
        // spendRequests.push(SpendingRequest);
    }

    function vote (uint idx) public req_amt_Raised userDonated {
        SpendDescription storage votingRequest = spendRequests[idx];
        require(votingRequest.voterDonars[msg.sender] == false);

        votingRequest.votes ++;
        votingRequest.voterDonars[msg.sender] = true;
    }

    function makeTransaction(uint idx) public isOwner req_amt_Raised {
        SpendDescription storage payRequest = spendRequests[idx];

        require(payRequest.votes > totalDonars/2);
        require(payRequest.closed == false);

        payable(payRequest.recipient).transfer(payRequest.required);
        payRequest.closed = true;
    }

    function payBack() public deadlineReached userDonated {
        require(fundRaised < amountRequired);
        payable(msg.sender).transfer(donations[msg.sender]);
        donations[msg.sender] = 0;
    }
}