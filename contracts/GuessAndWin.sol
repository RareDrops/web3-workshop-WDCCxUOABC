// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GuessAndWin {
    uint256 private secretNumber;
    address public winner;
    bool public gameActive = true;
    uint256 public balance;
    uint256 public totalPot;

    mapping(address => uint256) public contributions;

    event GuessMade(address indexed player, uint256 guess);
    event WinnerDeclared(address indexed winner, uint256 prize);

    // Store the secret number
    constructor(uint256 _secretNumber) {
        secretNumber = _secretNumber;
    }

    // Players deposit ETH and make a guess
    function depositAndGuess(uint256 _guess) external payable {
        require(gameActive, "Game has ended!");
        require(msg.value >= 0.01 ether, "Minimum deposit: 0.01 ETH");
        contributions[msg.sender] += msg.value;
        emit GuessMade(msg.sender, _guess);

        // Check if the guess is correct
        if (_guess == secretNumber) {
            winner = msg.sender;
            gameActive = false;

            balance = address(this).balance;
            require(balance > 0, "No funds to transfer");

            // Ensure the contract has enough balance before transferring
            require(
                address(this).balance >= balance,
                "Insufficient contract balance"
            );

            emit WinnerDeclared(winner, balance);

            // Transfer the balance to the winner's wallet
            payable(winner).transfer(balance);
        }
    }

    // Get the current pot amount
    function getPot() external view returns (uint256) {
        return address(this).balance; // return the contract's balance as the pot
    }
}
