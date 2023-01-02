pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is Ownable {

  event RecordTemp(address sender, int32 currentTempCelsius);

 // Solidity value/variable types : STATE variables: stored on the blockchain, their use engenders higher costs (gas)
 // Use of different types
  string public hint = "Use variables with parsimony!";
  address public fallbackOwner = 0xDfDfDF033E7248df0770FC9f02a0DE5AeE625cf6;  // use a secondary fallback address.
  uint public price = 0.0001 ether;
  int32 minTemp = 130000000; 
  int32 maxTemp = 160000000;
  int32 public currentTempCelsius; // Temperature can be positive or negative. Cannot be outside of the range of 32 bits. Nuclear fusion : 150.000.000°C
 
 // use of enums type. 
  enum riskLevels{ 
    SAFE,
    RISKY,
    PANIC
  }

  function setCurrentTemp(int32 _currentTempCelsius) public payable onlyOwner { // _currentTempCelsius is a CallData Type
     require(msg.value == price,"0.0001 ether needed");
      currentTempCelsius = _currentTempCelsius;
      emit RecordTemp(msg.sender, currentTempCelsius); // GLOBAL variable : msg.sender : Sender of the message
  }

   function isSafe() view public returns(bool) { // use of a boolean to return the current safety calculation result
    if(currentTempCelsius > minTemp && currentTempCelsius < maxTemp)
    {
      return true;
    }
    return false;
    
  }

  function getCurrentRiskLevel() view public returns(riskLevels){  // use of the enum to return a specific result. 
    int32 PanicTemp = 180000000; // LOCAL variables: NOT stored on the blockchain, less costs
    if(currentTempCelsius > minTemp && currentTempCelsius < maxTemp)
    {
      return riskLevels.SAFE;
     
    }
    else if(currentTempCelsius < PanicTemp) { return riskLevels.RISKY; }
      else { return riskLevels.PANIC; }
  }

  function setFallBackAddressByBytes(bytes20 input) public onlyOwner { // Use of Byte Type; Ethereum being a 20 bytes value, conversion is allowed
    fallbackOwner = address(input);
}

}
