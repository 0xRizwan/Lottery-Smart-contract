//SPDX-License-Identifier:MIT
// Contract created by Mohammed Rizwan

pragma solidity >=0.5.0 < 0.9.0;

contract Lottery {
 
 address owner;
 address payable[] participants;
 
 constructor(){
     owner = msg.sender;
 }
 
 modifier onlyOwner {
     require ( msg.sender == owner );
     _;
 }
 
 function Owner() public view returns(address){
     return msg.sender;
 }
 
 function getBalance() onlyOwner public view returns(uint){
     return address(this).balance;
 }
 
 receive() external payable {
     require ( msg.sender != owner, "Owner not send" );
     require ( msg.value == 1 ether, "Invalid amount" );
     participants.push(payable(msg.sender));
 }
 
 function transferAmount() public view returns(uint) {
     uint amount = (getBalance() / 100) * 80;
     return amount;
 }
 
 function random() onlyOwner public view returns(uint){
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
 }
 
 function Winner() onlyOwner public payable{
     address payable winner;
     uint index = random() % participants.length;
     winner = participants[index];
     winner.transfer(transferAmount());
     participants = new address payable[](0);
 }
 
}