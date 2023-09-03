// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

contract Lottery {
    address public owner;
    address payable[] public participents;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.0001 ether, "Minimum amount to participat is 1 Etherium");
        participents.push(payable(msg.sender));
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the Owner");
        _;
    }

    function participant(uint _index) public view returns(address) {
        return participents[_index];
    }

    function getBalance() public view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function random() private view returns(uint) {
        return uint(keccak256( abi.encodePacked (block.difficulty, block.timestamp, participents.length)));
    }

    function lotteryWinner() public onlyOwner {
        require(participents.length >= 3, "Participents are not enough");
        uint randomNumber = random();
        uint winnerIndex = randomNumber % participents.length;
        address payable winner = participents[winnerIndex];
        winner.transfer(getBalance());
        participents = new address payable[](0);
    }
}