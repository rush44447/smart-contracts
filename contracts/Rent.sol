// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract Rent {
    address owner;
    constructor(){
        owner = msg.sender;
    }

    struct Renter {
        address payable walletAddress;
        string firstname;
        string lastname;
        bool canRent;
        bool active;
        uint balance;
        uint due;
        uint start;
        uint end;
    }

    mapping(address => Renter) public renter;

    function addRenter(address payable walletAddress, string memory firstname, string memory lastname, bool canRent, bool active, uint balance, uint due, uint start, uint end) public {
      renter[walletAddress] = Renter(walletAddress, firstname, lastname, canRent, active, balance, due, start, end);
    }

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    function userBalance(address walletAddress) view public returns(uint) {
        return renter[walletAddress].balance;
    }

    function checkOut(address walletAddress) public {consol.log(1);
        require(renter[walletAddress].canRent == true, "Person can't rent");
        require(renter[walletAddress].due == 0, "Person has pending dues");
        renter[walletAddress].end = block.timestamp;
        renter[walletAddress].active = true;
        renter[walletAddress].canRent = false;
    }

    function checkIn(address walletAddress) public {
        require(renter[walletAddress].active == true, "Please check out a bike first.");
        renter[walletAddress].active = false;
        renter[walletAddress].end = block.timestamp;
        setDue(walletAddress);
    }

    function updateBalance(address walletAddress)  public {
        uint time = totalTime( renter[walletAddress].start,renter[walletAddress].end);
        renter[walletAddress].balance -= time;
     }

    function totalTime(uint start, uint end) internal pure returns(uint) {
        return end - start;
    }

    function getTime(address walletAddress) public view returns(uint) {
        require(renter[walletAddress].active == false, "Bike is in use");
        uint duration = totalTime(renter[walletAddress].start, renter[walletAddress].end);
        return duration;
    }

    function setDue(address walletAddress) public {
        uint time = getTime(walletAddress);
        uint units = time / 5;
        renter[walletAddress].due = units * 5000;
    }

    function canRentBike(address walletAddress) public view returns(bool){
        return renter[walletAddress].canRent;
    }

    function deposit(address walletAddress) payable public {
        renter[walletAddress].balance += msg.value;
    }

    function makePayment(address walletAddress) payable public {
//        require(renter[walletAddress].due > 0, "You don't have anything due at this time");
        require(renter[walletAddress].balance > msg.value, "Enough balance not available");
        renter[walletAddress].balance -=msg.value;
        renter[walletAddress].canRent = true;
        renter[walletAddress].due = 0;
        renter[walletAddress].start = 0;
        renter[walletAddress].end = 0;
    }
}
