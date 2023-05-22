// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Exchange.sol";

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

     function getExchange(address _tokenAddress)public view returns(address){
        return tokensToExchange[_tokenAddress];
     }   
        

}