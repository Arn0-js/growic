 pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

contract YourContract {

  struct userDetail{
    string  name; 
    uint256 age;
  }
  
  mapping(address => uint256) public balances;
  mapping(address => userDetail) public userDetails;
  uint256 private immutable Fee;
  address public owner = 0xDfDfDF033E7248df0770FC9f02a0DE5AeE625cf6;
  error unauthorized(); 
  error insufficientBalance();
  error insufficientAmount();
  error unexistingUser();
  error amountTooSmall();

  modifier amountCheck(uint256 _amount){
 if(msg.value < _amount) revert insufficientAmount();
  _;
}
constructor() {
  Fee = tx.gasprice;
}

/// deposit function storing the amount of deposited amount. 
  function deposit (uint256 amount) public payable amountCheck(amount) {
      balances[msg.sender] += amount; 
  }

 modifier existingDeposit(){
 uint256 tempBal = balances[msg.sender];
 if(tempBal == 0) revert unexistingUser();
  _;
}

modifier checkFee(uint256 _amount){
// console.log("Fee comparison with the amount:",Fee," < ",_amount);
if(_amount<Fee) revert amountTooSmall();
 _;
}

function addFund (uint256 amount) public payable existingDeposit() checkFee(amount){
  balances[msg.sender] += amount;
}

modifier ownerOnly{
 if(msg.sender != owner) revert unauthorized();
  _;
}

function withdraw (uint256 amount) public ownerOnly {
  uint256 availableBal = balances[msg.sender]; 
  if(amount>availableBal) revert insufficientBalance();
  (bool success, ) = msg.sender.call{value: amount}("");
}

/// return the current balance of the user (sender)
  function checkBalance() view public returns(uint256){
    uint256 tempBal = balances[msg.sender];
   // console.log("Check balance for ",msg.sender, ": ",tempBal);
    return tempBal; //balances[msg.sender]
  }

/// function allowing user (sender) to set their personnal details 
  function setUserDetails(string calldata name, uint256 age) public{ 
   userDetails[msg.sender] = userDetail(name,age);
  }

/// returns the personnal details of the user (sender)
  function getUserDetail() view public returns(string memory name, uint256 age){
   userDetail memory det=userDetails[msg.sender];
   return (det.name, det.age);
  }

}
