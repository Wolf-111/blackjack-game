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
        it("player is added", async (): Promise<void> => {
            const [owner, addr1] = await ethers.getSigners();
            let players: boolean = await blackjackContract.players(addr1.address);
            assert.isFalse(players);
            // await blackjackContract.enterTournament();
            // let updatedPlayers: boolean = await blackjackContract.players(addr1.address);
            // console.log(updatedPlayers)
        });
    })
});

describe("BLJCoin", (): void => {
    let bljCoinContract = null;
    before(async (): Promise<void> => {
        const BLJCoin: any = await ethers.getContractFactory("BLJCoin");
        const bljCoin: any = await BLJCoin.deploy(1000000);
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