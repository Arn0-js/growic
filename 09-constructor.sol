pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

contract A {

    address private immutable owner;
    uint public FEE;
    
    constructor(uint _fee) {
      owner= msg.sender;
      FEE = _fee;
    }


}

contract B is A {

address public immutable owner; 

  constructor() A(20) {
     owner= msg.sender;
  }

   function getOWner() public view returns(address)
   {  return owner; }

}
