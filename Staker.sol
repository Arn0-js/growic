// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;
  ExampleExternalContract public exampleExternalContract;
  event FundsStaked(address indexed user, uint256 amount);
  uint256 public deadline = block.timestamp + 30 seconds;
  bool openForWithdraw = false;
  bool alreadyExecuted = false;

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable{
    balances[msg.sender] += msg.value; 
     emit FundsStaked(msg.sender,amount);
  }

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public{
    if(block.timestamp >= deadline && !alreadyExecuted)  // allow execute() fonction only "after the deadline has expired"
   { alreadyExecuted=true;    //  allow execute() just once
      if(address(this).balance >= threshold)
       exampleExternalContract.complete{value: address(this).balance}();
      else openForWithdraw=true;
   }
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
  function withdraw() public{
    if(address(this).balance < threshold && openForWithdraw)
      { 
       uint256 availableBal = balances[msg.sender]; 
       (bool success, ) = msg.sender.call{value: availableBal}("");
      }
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns(uint256){ 
    if(block.timestamp >= deadline) return 0;
    else return deadline-block.timestamp;
  }

  // Add the `receive()` special function that receives eth and calls stake()
  // received function, calling itself the previously developped deposit() function.
  receive() external payable{
    stake();
}
}
