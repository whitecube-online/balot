const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const { before, beforeEach } = require("mocha");
const fs = require("fs");

const dotenv = require("dotenv");
const { min } = require("bn.js");
dotenv.config();

const BALOT_ABI = JSON.parse(
  fs.readFileSync(__dirname + "/../assets/Balot.abi")
);

const ADDRESSES = {
  balot: "0x6b877dfaf74b22913a494d1fc95d7e30c2b88ea1",
  safe: "0xf078544e774faf5d10dd04c43f443a80c917c49c",
};

describe("All good scenario", async () => {
  let minterOwner, minter, balotFromSafe, initialSafeBalance;

  before(async () => {
    await network.provider.request({
      method: "hardhat_reset",
      params: [
        {
          forking: {
            jsonRpcUrl: `${process.env.ARCHIVE_NODE_API}`,
            blockNumber: 14878670,
          },
        },
      ],
    });

    // Give ETH to safe to allow it to perform calls
    await network.provider.send("hardhat_setBalance", [
      ADDRESSES.safe,
      "0x10000000000000000",
    ]);
    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [ADDRESSES.safe],
    });
  });
  after(async () => {
    await network.provider.request({
      method: "hardhat_stopImpersonatingAccount",
      params: [ADDRESSES.safe],
    });
  });

  it("Step 1/3: deploy minter", async () => {
    [minterOwner] = await ethers.getSigners();

    const Minter = await ethers.getContractFactory("Minter", minterOwner);
    minter = await Minter.deploy();
  });

  it("Step 2/3: transfer Balot ownership", async () => {
    const safeSigner = await ethers.getSigner(ADDRESSES.safe);
    balotFromSafe = new ethers.Contract(ADDRESSES.balot, BALOT_ABI, safeSigner);

    initialSafeBalance = parseInt(
      await balotFromSafe.balanceOf(ADDRESSES.safe)
    );

    await balotFromSafe.transferOwnership(minter.address);

    expect((await balotFromSafe.owner()).toUpperCase()).to.equal(
      minter.address.toUpperCase()
    );
  });

  it("Step 3/3: safe mint range", async () => {
    await minter.safeMintRange(
      ADDRESSES.balot,
      ADDRESSES.safe,
      ADDRESSES.safe,
      1,
      300
    );

    const newSafeBalance = parseInt(
      await balotFromSafe.balanceOf(ADDRESSES.safe)
    );
    expect(newSafeBalance).to.equal(initialSafeBalance + 300);
    expect((await balotFromSafe.owner()).toUpperCase()).to.equal(
      ADDRESSES.safe.toUpperCase()
    );
  });
});

describe("Failing mint & reverting scenario", async () => {
  let minterOwner, minter, balotFromSafe;

  before(async () => {
    await network.provider.request({
      method: "hardhat_reset",
      params: [
        {
          forking: {
            jsonRpcUrl: `${process.env.ARCHIVE_NODE_API}`,
            blockNumber: 14878670,
          },
        },
      ],
    });

    // Give ETH to safe to allow it to perform calls
    await network.provider.send("hardhat_setBalance", [
      ADDRESSES.safe,
      "0x10000000000000000",
    ]);
    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [ADDRESSES.safe],
    });
  });
  after(async () => {
    await network.provider.request({
      method: "hardhat_stopImpersonatingAccount",
      params: [ADDRESSES.safe],
    });
  });

  it("Step 1/4: deploy minter", async () => {
    [minterOwner] = await ethers.getSigners();

    const Minter = await ethers.getContractFactory("Minter", minterOwner);
    minter = await Minter.deploy();
  });

  it("Step 2/4: transfer Balot ownership", async () => {
    const safeSigner = await ethers.getSigner(ADDRESSES.safe);
    balotFromSafe = new ethers.Contract(ADDRESSES.balot, BALOT_ABI, safeSigner);

    initialSafeBalance = parseInt(
      await balotFromSafe.balanceOf(ADDRESSES.safe)
    );

    await balotFromSafe.transferOwnership(minter.address);

    expect((await balotFromSafe.owner()).toUpperCase()).to.equal(
      minter.address.toUpperCase()
    );
  });
  it("Step 3/4: safe mint range FAILED", async () => {
    await expect(
      minter.safeMintRange(
        ADDRESSES.balot,
        ADDRESSES.safe,
        ADDRESSES.safe,
        1,
        1000
      )
    ).to.be.revertedWith(
      "Transaction reverted: contract call run out of gas and made the transaction revert"
    );
  });
  it("Step 4/4: transfer Balot ownership back to Safe", async () => {
    await minter.transferCollection(ADDRESSES.balot, ADDRESSES.safe);

    expect((await balotFromSafe.owner()).toUpperCase()).to.equal(
      ADDRESSES.safe.toUpperCase()
    );
  });
});
