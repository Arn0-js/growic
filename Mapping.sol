pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

contract YourContract {

  mapping(address => uint256) public balances;

  function deposit (uint256 amount) public payable {
     // require(msg.value = amount,"Please pay the amount"); not requested. 
      balances[msg.sender] += amount; // add the amount to the existing balance (0 being the default value, works too for empty balance)
      console.log(amount," added for ",msg.sender);
  }

  function checkBalance() view public returns(uint256){
    uint256 tempBal = balances[msg.sender];
    console.log("Check balance for ",msg.sender, ": ",tempBal);
    return tempBal; //balances[msg.sender]
  }

}
