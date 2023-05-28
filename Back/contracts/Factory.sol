// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Exchange.sol";
/*Factory contract performs following functions :
  1) Holds a registry for Exchanges against the tokens they will deal in 
  2) Lets user to create a new Exchange for a given token
  3) Lets Exchanges query each other using the getExchange function 
  NOTE : Here Exchange refers to the Eth-Token liquidity pool for that token*/


contract Factory{
    mapping(address=>address) public tokensToExchange;

    // function to create a new exchange against the token
    function createExchange(address _tokenAddress)public returns(address){
        require(_tokenAddress !=address(0), "Invalid token Address");

        require(tokensToExchange[_tokenAddress]== address(0), "The exchange already exists");

        Exchange exchange = new Exchange(_tokenAddress);
        tokensToExchange[_tokenAddress] = address(exchange);

        return address(exchange);
    }
    // This is the function to query the exchange against any token.
     function getExchange(address _tokenAddress)public view returns(address){
        return tokensToExchange[_tokenAddress];
     }   
        

}