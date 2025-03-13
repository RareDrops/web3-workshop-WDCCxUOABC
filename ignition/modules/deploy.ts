import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const GuessAndWinModule = buildModule("GuessAndWinModule", (m) => {
    const secretNumber = 42; // Set your desired secret number

    const guessAndWin = m.contract("GuessAndWin", [secretNumber]);

    return { guessAndWin };
});

export default GuessAndWinModule;
