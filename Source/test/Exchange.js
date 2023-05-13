// SPDX-License-Identifier: UNLICENSED
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Test for Exchange contract", async function () {
  it("Should add liquidity to the smart contract", async function () {
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy(
      "Chutiya123",
      "C",
      ethers.utils.parseEther("5000")
    );
    const Exchange = await ethers.getContractFactory("Exchange");
    const exchange = await Exchange.deploy(token.address);
    const tokenAmount = ethers.utils.parseEther("200");
    const ethAmount = ethers.utils.parseEther("100");
    await token.approve(exchange.address, tokenAmount);
    await exchange.addLiquidity(tokenAmount, { value: ethAmount });
    expect(await exchange.getContractBalance()).to.equal(ethAmount);
    expect(await exchange.getReserve()).to.equal(tokenAmount);
  });

  it("Should get the price of Token", async function () {
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy(
      "Test",
      "Tt",
      ethers.utils.parseEther("5000")
    );
    const Exchange = await ethers.getContractFactory("Exchange");
    const exchange = await Exchange.deploy(token.address);
    const tokenAmount = ethers.utils.parseEther("2000");
    const ethAmount = ethers.utils.parseEther("1000");
    await token.approve(exchange.address, tokenAmount);
    await exchange.addLiquidity(tokenAmount, { value: ethAmount });

    const tokenReserve = await exchange.getReserve();
    const ethReserve = await exchange.getContractBalance();

    expect((await exchange.getPrice(tokenReserve, ethReserve)).toString()).to.equal("2");
  });

  it("Should return the correct token amount", async function(){
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy(
      "Test",
      "Tt",
      ethers.utils.parseEther("5000")
    );
    const Exchange = await ethers.getContractFactory("Exchange");
    const exchange = await Exchange.deploy(token.address);
    const tokenAmount = ethers.utils.parseEther("2000");
    const ethAmount = ethers.utils.parseEther("1000");
    await token.approve(exchange.address, tokenAmount);
    await exchange.addLiquidity(tokenAmount, { value: ethAmount });

    let tokensOut = await exchange.getTokenAmount(ethers.utils.parseEther("1"));
    expect(ethers.utils.formatEther(tokensOut)).to.equal("1.998001998001998001");
  })
});
