import React from "react";
import { useState } from "react";

const Navbar = () => {
  const [walletAddress, setWalletAddress] = useState("");
  async function requestAccount() {
    console.log("Requesting Accounts...");

    if (window.ethereum) {
      console.log("Detected");
      try {
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        console.log(accounts);
        setWalletAddress(accounts[0]);
      } catch (error) {
        console.log(error);
      }
    }
  }

  return (
    <div>
      <header className="text-gray-400 bg-blue-800 body-font">
        <div className="container mx-auto flex flex-wrap p-5 flex-col md:flex-row items-center relative">
          <a className="flex title-font font-medium items-center text-white mb-4 md:mb-0">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              className="w-10 h-10 text-white p-2 bg-blue-500 rounded-full"
              viewBox="0 0 24 24"
            >
              <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"></path>
            </svg>
            <span className="ml-3 text-xl">JellySwap</span>
          </a>
          <nav className="md:mr-auto md:ml-4 md:py-1 md:pl-4 md:border-l md:border-gray-700	flex flex-wrap items-center text-base justify-center">
            <a className="mr-5 hover:text-white">Swap</a>
            <a className="mr-5 hover:text-white">Token</a>
            <a className="mr-5 hover:text-white">Pools</a>
            {/* <a className="mr-5 hover:text-white">Gaand Mara</a> */}
          </nav>
          <div className="flex-items-center justify-center mr-20">
            Connected Wallet : {walletAddress}
          </div>
          <button
            className="inline-flex items-center bg-gray-800 border-0 py-1 px-3 focus:outline-none hover:bg-gray-700 rounded text-base mt-4 mr-10 md:mt-0"
            onClick={requestAccount}
          >
            Connect Wallet
          </button>
        </div>
      </header>
    </div>
  );
};

export default Navbar;
