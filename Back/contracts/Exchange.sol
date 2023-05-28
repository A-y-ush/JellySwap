// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IExchange {
    function ethToTokenSwap(uint256 _minTokens) external payable;

    function ethTotokenTransfer(
        uint256 _minTokens,
        address recipient
    ) external payable;
}

interface IFactory {
    function getExchange(address _tokenAddress) external returns (address);
}

contract Exchange is ERC20 {
    address public tokenAddress;
    address public factoryAddress;

    constructor(address _token) ERC20("JellySwap-V1", "Jelly-V1") {
        require(_token != address(0), "Invalid token address");
        tokenAddress = _token;
        factoryAddress = msg.sender; 
        // the factory contract will be the creater of this smart contract
    }

    function addLiquidity(
        uint256 _tokenAmount
    ) public payable returns (uint256) {
        // This part is used to add initial liquidity to the contract
        if (getReserve() == 0) {
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), _tokenAmount);
            uint256 liquidity = address(this).balance;
            _mint(msg.sender, liquidity);
            return liquidity;
        } else {
            // This part is used when the initial liquidity is set
            uint256 ethReserve = getContractBalance() - msg.value;
            uint256 tokenReserve = getReserve();
            uint256 tokenAmount = (msg.value * tokenReserve) / ethReserve;
            require(
                _tokenAmount >= tokenAmount,
                "Insufficient amount of tokens added "
            );
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), _tokenAmount);
            uint256 liquidity = (totalSupply() * msg.value) / ethReserve;
            _mint(msg.sender, liquidity); // minting the tokens
            return liquidity; // returning the amount of tokens minted
        }
    }

    // function to get the amount of tokens whose address is passed in the line one.
    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    // Function to get the amount of ethers deposited to smart contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // ->Function to get the amount of tokens and ethers
    // ->>here we have calculated the amount of tokens that would be given after taking the
    // ->>transaction fees.
    function getAmount(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) private pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "Invalid Reserve");
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = inputAmountWithFee + (inputReserve * 100);
        return numerator / denominator;
    }

    // To get the amount of token againt the ethers deposited
    function getTokenAmount(uint256 _ethSold) public view returns (uint256) {
        require(_ethSold > 0, "Ether amount sold is very small");
        uint256 tokenReserve = getReserve();
        uint256 etherReserve = getContractBalance();
        return getAmount(_ethSold, etherReserve, tokenReserve);
    }

    // To get the amount of ethers against the tokens deposited
    function getEthAmount(uint256 _tokenSold) public view returns (uint256) {
        require(_tokenSold > 0, "Token amount sold is very small");
        uint256 tokenReserve = getReserve();
        uint256 ethReserve = getContractBalance();
        return getAmount(_tokenSold, tokenReserve, ethReserve);
    }

    // function to transfer 
    function ethToToken(uint256 minTokens, address recipient) private {
        uint256 tokenReserve = getReserve();
        uint256 ethReserve = getContractBalance();
        uint256 tokensBought = getAmount(
            msg.value,
            ethReserve - msg.value,
            tokenReserve
        );
        require(tokensBought > minTokens, "Amount is too low ");
        IERC20(tokenAddress).transfer(recipient, tokensBought);
    }

    function EthToTokenSwap(uint256 _minTokens) public payable {
        ethToToken(_minTokens, msg.sender);
    }

    function EthToTokenTransfer(
        uint256 minTokens,
        address recipient
    ) public payable {
        ethToToken(minTokens, recipient);
    }

    // fucntion to swap tokens to ethers
    function tokenToEthSwap(uint256 tokenSold, uint256 minEth) public payable {
        uint256 tokenReserve = getReserve();
        uint256 ethReserve = getContractBalance();
        uint256 ethBought = getAmount(
            msg.value,
            tokenReserve - msg.value,
            ethReserve
        );
        require(ethBought > minEth, "Eth amount is too low ");
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), tokenSold);
        payable(msg.sender).transfer(ethBought);
    }

    // Function to remove liquidity from the contract and returning the ethers and tokens to the
    // persons account
    function removeLiquidity(
        uint256 _amount
    ) public returns (uint256, uint256) {
        require(_amount > 0, "The amount is insufficient");
        uint256 ethAmount = (address(this).balance * _amount) / totalSupply();
        uint256 tokenAmount = (getReserve() * _amount) / totalSupply();

        payable(msg.sender).transfer(ethAmount);
        IERC20(tokenAddress).transfer(msg.sender, tokenAmount);
        return (ethAmount, tokenAmount);
    }
    /*The following function is used to :
      1)Swap two tokens directly using their addresses. */
    function tokenTotokenSwap(
        uint256 _tokensSold,
        uint256 _minTokensBought,
        address _tokenAddress
    ) public {
        address exchangeAddress = IFactory(factoryAddress).getExchange(
            _tokenAddress
        );
        require(
            exchangeAddress != address(this) && exchangeAddress != address(0),
            "Invalid exchange address"
        );
        uint256 tokenReserve = getReserve();
        uint256 ethBought = getAmount(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );

        IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokensSold
        );

        IExchange(exchangeAddress).ethTotokenTransfer{value: ethBought}(
            _minTokensBought,
            msg.sender
        );
    }
}
