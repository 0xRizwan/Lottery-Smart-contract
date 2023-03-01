// SPDX-License-Identifier:MIT
// Contract created by Mohammed Rizwan

/* Problem statement- Write a Write a Solidity program for a lottery program. The lottery should accept 1 ETH from two 
   participants. Once two participants send 1 ETH each to the contract; the contract should pick a winner, send 1.8 ETH to 
   the winner, and 0.2 ETH to a hardcoded address (developer address).
*/

pragma solidity ^0.8.0;

contract Lottery {

    address public owner;

    // Dynamic array to store the number of participants
    address payable[] public participants;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require (owner == msg.sender, "Only manager can access this function");
        _;
    }

    // Receive function only creates once in a smart contract. This help to transfer the ether.
    // Receive is always used with external and payable keyword.
    receive() external payable {
        //require is used as a error handling method. It checks the require conditions to be true then only run below code.
        require (owner != msg.sender, "Owner can not participate in lottery");
        require (msg.value == 1 ether, "The amount is invalid, Enter the correct lottery amount");
        participants.push(payable(msg.sender));
    }

    function getBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }

    //this random function will genrate random value and from participant array and then used to return to the winner.
    function random() private view returns(uint){
        return uint (keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length)));
    }

    function selectWinner() public payable onlyOwner{
        require(participants.length >= 2, "Participants must be atleat 2 Nos.");
        uint r = random();  
        uint index = r % participants.length; 

        address payable winner;
        winner = participants[index];
        uint balance = getBalance();      
        uint fee = balance / 100 * 10;
        uint amountToTransfer = balance - fee;

        (bool success, ) = winner.call{value:amountToTransfer} ("");
        require(success, "Transaction is failed");

        (bool managerSuccess, ) = payable(owner).call{value:fee}("");
        require(managerSuccess, "Transaction is failed");

        participants=new address payable[](0);
}

}
