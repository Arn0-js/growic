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

/// deposit function allowing user to populate their balance. 
  function deposit (uint256 amount) public payable {
     // require(msg.value = amount,"Please pay the amount"); not requested. 
      balances[msg.sender] += amount; // add the amount to the existing balance (0 being the default value, works too for empty balance)
      console.log(amount," added for ",msg.sender);
  }

/// return the current balance of the user (sender)
  function checkBalance() view public returns(uint256){
    uint256 tempBal = balances[msg.sender];
    console.log("Check balance for ",msg.sender, ": ",tempBal);
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
