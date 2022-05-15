const { assert } = require("chai");
const { ethers } = require("hardhat");

describe("Contract", function() {
    before(async() => {
        const Contract = await ethers.getContractFactory("Contract");
        const contract = await Contract.deploy();
        await contract.deployed();
    });

    it("test", () => {
        assert.equal(5, 5)
    });
});