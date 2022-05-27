const { expect } = require("chai");
const { ethers } = require("hardhat");
const { beforeEach } = require("mocha");

const baseUri = "https://example.com/";

describe("Balot", async () => {
  let balot, owner;

  beforeEach(async () => {
    [owner] = await ethers.getSigners();

    const Balot = await ethers.getContractFactory("src/Balot.sol:Balot", owner);

    balot = await Balot.deploy(owner.address, baseUri);

    const uri0 = "metadata0.json";

    const tx = await balot.safeMint(owner.address, uri0);
    await tx.wait();
  });
  it("should setup with a first token minted to the deployer", async () => {
    expect(await balot.ownerOf(0), owner.address);
  });
  it("should allow transferring ownership", async () => {
    const [, minterOwner] = await ethers.getSigners();

    await balot.transferOwnership(minterOwner.address);
    expect(await balot.owner()).to.equal(minterOwner.address);
  });

  describe("Minter.safeMintRange in order", async () => {
    let minter, minterOwner, nextOwner, recipient;

    beforeEach(async () => {
      [, minterOwner, nextOwner, recipient] = await ethers.getSigners();

      const Minter = await ethers.getContractFactory("Minter", minterOwner);

      // 1. Deploy Minter
      minter = await Minter.deploy();

      // 2. Tranfer Balot ownership to minter
      await balot.transferOwnership(minter.address);

      const start = 1,
        end = 300,
        step = 1;
      // 3. Range mint + transfer Balot ownership
      await minter.safeMintRange(
        balot.address,
        nextOwner.address,
        recipient.address,
        start,
        end,
        step
      );
    });

    it("should transfer ownership", async () => {
      expect(await balot.owner()).to.be.equal(nextOwner.address);
    });
  });

  describe("Minter.safeMintRange by attacker", async () => {
    let minter, minterOwner, nextOwner, recipient;

    beforeEach(async () => {
      [
        ,
        minterOwner,
        nextOwner,
        recipient,
        attacker,
        attackerNextOwner,
        attackerRecipient,
      ] = await ethers.getSigners();

      const Minter = await ethers.getContractFactory("Minter", minterOwner);

      // 1. Deploy Minter
      minter = await Minter.deploy();

      // 2. Tranfer Balot ownership to minter
      await balot.transferOwnership(minter.address);
    });

    it("should not be allowed", async () => {
      const start = 1,
        end = 300,
        step = 1;

      const attackedMinter = await minter.connect(attacker);
      await attackedMinter.safeMintRange(
        balot.address,
        attackerNextOwner.address,
        attackerRecipient.address,
        start,
        end,
        step
      );

      const actualNewOwnerAddr = await balot.owner();

      expect(actualNewOwnerAddr).to.not.be.equal(attackerNextOwner.address);
      expect(actualNewOwnerAddr).to.be.equal(owner.address);
      expect(await balot.balanceOf(attackerRecipient.address)).to.equal(0);
    });
  });
});