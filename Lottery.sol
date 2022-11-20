//SPDX-License-Identifier:MIT
// Contract created by Mohammed Rizwan

pragma solidity >=0.7.0 < 0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

    modifier onlyManager(){
        require (manager == msg.sender, "Only manager can access this function");
        _;
    }

    receive() external payable {
        require (manager != msg.sender, "Manager can not send");
        require (msg.value == 1 ether, "The amount is invalid");
        participants.push(payable(msg.sender));
    }

    function getBalance() public view onlyManager returns(uint) {
        return address(this).balance;
    }

    function random() public view onlyManager returns(uint){
        return uint (keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public onlyManager{
        require (participants.length >= 3);
        address payable winner;
        uint index = random() % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}
