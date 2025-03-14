// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GuessAndWin {
    uint256 private secretNumber;
    address public winner;
    bool public gameActive = true;
    uint256 public balance;
    uint256 public totalPot;
    uint256 public maxNumber = 256;
    uint256 public minNumber = 0;
    address public owner;

    mapping(address => uint256) public contributions;

    event GuessMade(address indexed player, uint256 guess);
    event WinnerDeclared(address indexed winner, uint256 prize);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Store the secret number and set the contract owner
    constructor(uint256 _secretNumber) {
        require(
            _secretNumber >= minNumber && _secretNumber <= maxNumber,
            "Secret number must be within range"
        );
        secretNumber = _secretNumber;
        owner = msg.sender;
    }

    // Players deposit ETH and make a guess
    function depositAndGuess(uint256 _guess) external payable {
        require(gameActive, "Game has ended!");
        require(msg.value >= 0.01 ether, "Minimum deposit: 0.01 ETH");
        require(
            _guess >= minNumber && _guess <= maxNumber,
            "Guess must be within range"
        );

        contributions[msg.sender] += msg.value;
        emit GuessMade(msg.sender, _guess);

        // Check if the guess is correct
        if (_guess == secretNumber) {
            winner = msg.sender;
            gameActive = false;

            balance = address(this).balance;
            require(balance > 0, "No funds to transfer");

            emit WinnerDeclared(winner, balance);

            // Transfer the balance to the winner's wallet
            payable(winner).transfer(balance);
        }
    }

    // Get the current pot amount
    function getPot() external view returns (uint256) {
        return address(this).balance;
    }

    // Owner can withdraw remaining funds if no winner is declared
    function withdrawFunds() external onlyOwner {
        require(gameActive, "Game already has a winner, cannot withdraw");
        uint256 amount = address(this).balance;
        require(amount > 0, "No funds to withdraw");

        emit FundsWithdrawn(owner, amount);
        payable(owner).transfer(amount);
    }
}
