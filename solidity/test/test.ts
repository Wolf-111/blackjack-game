const { assert } = require("chai");
const { ethers } = require("hardhat");

describe("Contract", (): void => {
    before(async (): Promise<void> => {
        const Contract: any = await ethers.getContractFactory("Contract");
        const contract: any = await Contract.deploy();
        await contract.deployed();
    });

    it("test", (): void => {
        assert.equal(5, 5)
    });
});