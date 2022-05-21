const { assert } = require("chai");
const { ethers } = require("hardhat");

describe("Blackjack", (): void => {
    let blackjackContract = null;
    before(async (): Promise<void> => {
        const Blackjack: any = await ethers.getContractFactory("Blackjack");
        const blackjack: any = await Blackjack.deploy();
        blackjackContract = await blackjack.deployed();
    });

    it("dealer is initiated", async (): Promise<void> => {
        assert.exists(await blackjackContract.dealer());
    });

    describe("enterTournament()", (): void => {
        it("call enterTournament() function", async (): Promise<void> => {
            const signers: object = await ethers.getSigners();
            await blackjackContract.connect(signers[1]).enterTournament();
        });

        it("player is added to tournament", async (): Promise<void> => {
            const signers: object = await ethers.getSigners();
            let player: boolean = await blackjackContract.players(signers[1].address);
            assert.isTrue(player)
        });

        it("player recieves funding (10,000 BLJCoins)", async (): Promise<void> => {
            const signers: object = await ethers.getSigners();
            let playerBalance: boolean = await blackjackContract.playerBalances(signers[1].address);
            assert.equal(playerBalance, 10000)
        });
    });

    describe("startHand()", (): void => {
        it("call startHand()", async (): Promise<void> => {
            const signers: object = await ethers.getSigners();
            await blackjackContract.connect(signers[1]).startHand();
        });
        // it("hand becomes active", async (): Promise<void> => {
        //     const signers: object = await ethers.getSigners();
        //     let isHandActive = await blackjackContract.connect(signers[1]).isHandActive();
        //     assert.isTrue(isHandActive)
        // });
        describe("generateCard()", (): void => {
            // it("returns a random number between 1-11", async (): Promise<void> => {
            //     let randomNumber: any = await blackjackContract.generateCards();
            //     let f: any = await blackjackContract.generateDealersHand();

            //     console.log(randomNumber)
            //     console.log(f)
            //     // assert.isAtLeast(randomNumber, 1)
            //     // assert.isAtMost(randomNumber, 11)
            // });
        });
    });
});

describe("BLJCoin", (): void => {
    let bljCoinContract = null;
    before(async (): Promise<void> => {
        const BLJCoin: any = await ethers.getContractFactory("BLJCoin");
        const bljCoin: any = await BLJCoin.deploy(10000000);
        bljCoinContract = await bljCoin.deployed();
    });

    it("test", (): void => {
        assert.equal(5, 5)
    });
});

describe("NFTAward", (): void => {
    let nftAwardContract = null;
    before(async (): Promise<void> => {
        const NFTAward: any = await ethers.getContractFactory("NFTAward");
        const nftAward: any = await NFTAward.deploy();
        nftAwardContract = await nftAward.deployed();
    });

    it("test", (): void => {
        assert.equal(5, 5)
    });
});