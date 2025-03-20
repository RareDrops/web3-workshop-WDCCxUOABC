import { expect } from "chai";
import { ethers } from "hardhat";
import { GuessAndWin } from "../typechain-types";

describe("GuessAndWin", function () {
  let contract: GuessAndWin;
  let owner: any, player1: any, player2: any;
  const secretNumber = 42;

  beforeEach(async function () {
    [owner, player1, player2] = await ethers.getSigners();

    const GuessAndWin = await ethers.getContractFactory("GuessAndWin");
    contract = (await GuessAndWin.deploy(secretNumber)) as GuessAndWin;
    await contract.waitForDeployment();
  });

  it("Should allow a player to make a guess", async function () {
    await contract.connect(player1).makeGuess(10);
  });

  it("Should allow a player to make a guess and win", async function () {
    await contract.connect(player1).makeGuess(secretNumber);
  });

  it("Should not allow a player to make a guess after winning", async function () {
    await contract.connect(player1).makeGuess(secretNumber);
    await expect(
      contract.connect(player1).makeGuess(secretNumber)
    ).to.be.revertedWith("You have already won");
  });
});
