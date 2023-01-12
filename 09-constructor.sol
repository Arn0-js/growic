pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

contract A {

    address public immutable owner;
    uint public FEE;
    
    constructor(uint _fee) {
      owner= msg.sender;
      FEE = _fee;
    }


}

contract B is A {

  // Note to mentor:
  // Instructions says :  contract B should also have an owner variable that is set in the constructor
  // BUT
  // - owner is inherited from A. (so, as is, owner is set and public when contract B is deployed)
  // - We can only override functions in Solidity, not variables.
  // Immutable variables must be initialized in the constructor of the contract they are defined in. 
   

  constructor() A(20) {
    // owner= msg.sender;
  }

}
