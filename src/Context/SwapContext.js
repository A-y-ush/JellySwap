import React , { useEffect , useState } from 'react';
import {ethers} from 'ethers';

const {ethereum} = window;

const getEthereumContract = ()=>{
    const provider = new ethers.providers.Web3Provider(ethereum);
    const signer = provider.getSigner();
    const transactionContract = new ethers.Contract(contractAddress, contractABI , signer);
    console.log({
        provider,
        signer,
        transactionContract
    });
}

const connectWallet = async()=>{
    try {
        if(!ethereum) return alert("Please Install Metamask");

        const accounts = await ethereum.request({ method : 'eth_requestAccounts'});

       
        
    } catch (error) {
        console.log(error);

        throw new Error("No Ethereum Object ")
    }
}

