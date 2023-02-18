// SPDX-License-Identifier: MIT
// https://goerli.etherscan.io/address/0xb687426ae07f2538e7f10e48dfefcac9acad7d15
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;
 
  event Stake(address indexed user, uint256 amount);
  uint256 public deadline = block.timestamp + 48 hours;
  bool openForWithdraw = false;
  bool alreadyExecuted = false;
  error alreadyCompleted();
  ExampleExternalContract public exampleExternalContract;


  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

   modifier notCompleted(){
    if(exampleExternalContract.completed()) revert alreadyCompleted();
  _;
}
// modifier deadlinePassed(bool requireDeadlinePassed) {
//     uint256 timeRemaining = timeLeft();
//     if (requireDeadlinePassed) {
//       require(timeRemaining <= 0, "Deadline has not been passed yet");
//     } else {
//       require(timeRemaining > 0, "Deadline is already passed");
//     }
//     _;
//   }


  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable{
    balances[msg.sender] += msg.value; 
     emit Stake(msg.sender,msg.value);
  }

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public notCompleted(){
    if(block.timestamp >= deadline && !alreadyExecuted)  // allow execute() fonction only "after the deadline has expired"
   { alreadyExecuted=true;    //  allow execute() just once
      console.log("alreadyExecuted just set to true");
      if(address(this).balance >= threshold)
      {  exampleExternalContract.complete{value: address(this).balance}();
       console.log("exampleExternalContract.complete just called.");
       }
      else openForWithdraw=true;
   }
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
  function withdraw() public notCompleted(){
    if(address(this).balance < threshold && openForWithdraw)
      { 
       uint256 availableBal = balances[msg.sender]; 
       (bool success, ) = msg.sender.call{value: availableBal}("");
       if(success) balances[msg.sender] -= 0; 
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
