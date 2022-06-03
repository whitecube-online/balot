import { expect } from "chai";
import { beforeEach } from "mocha";

import { Contract } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

const baseUri = "https://example.com/";

describe("Balot", async () => {
  let balot: Contract, owner: SignerWithAddress;

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
    let minter: Contract,
      minterOwner: SignerWithAddress,
      recipient: SignerWithAddress;

    beforeEach(async () => {
      [, minterOwner, recipient] = await ethers.getSigners();

      const Minter = await ethers.getContractFactory("Minter", minterOwner);

      // 1. Deploy Minter
      minter = await Minter.deploy();

      // 2. Transfer Balot ownership to minter
      await balot.transferOwnership(minter.address);

      const start = 1,
        end = 300;
      // 3. Range mint + transfer Balot ownership
      await minter.safeMintRange(balot.address, recipient.address, start, end);
    });
  });

  describe("Minter.safeMintRange by attacker", async () => {
    let minter: Contract,
      minterOwner: SignerWithAddress,
      attacker: SignerWithAddress,
      attackerRecipient: SignerWithAddress;

    beforeEach(async () => {
      [, minterOwner, attacker, attackerRecipient] = await ethers.getSigners();

      const Minter = await ethers.getContractFactory("Minter", minterOwner);

      // 1. Deploy Minter
      minter = await Minter.deploy();

      // 2. Transfer Balot ownership to minter
      await balot.transferOwnership(minter.address);
    });

    it("should not be allowed", async () => {
      const start = 1,
        end = 300;

      const attackedMinter = await minter.connect(attacker);
      await expect(
        attackedMinter.safeMintRange(
          balot.address,
          attackerRecipient.address,
          start,
          end
        )
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });
  });

  describe("Failing Minter.safeMintRange", async () => {
    let minter: Contract,
      minterOwner: SignerWithAddress,
      recipient: SignerWithAddress;

    beforeEach(async () => {
      [, minterOwner, recipient] = await ethers.getSigners();

      const Minter = await ethers.getContractFactory("Minter", minterOwner);

      // 1. Deploy Minter
      minter = await Minter.deploy();

      // 2. Transfer Balot ownership to minter
      await balot.transferOwnership(minter.address);

      const start = 1,
        end = 9999;
      // 3. Range mint + transfer Balot ownership
      await expect(
        minter.safeMintRange(balot.address, recipient.address, start, end)
      ).to.be.revertedWith(
        "Transaction reverted: contract call run out of gas and made the transaction revert"
      );
    });

    it("should still be transferrable", async () => {
      await minter.transferCollection(balot.address, owner.address);

      expect(await balot.owner()).to.be.equal(owner.address);
    });
  });
});
