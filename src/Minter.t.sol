// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";
import {ERC721Holder} from "openzeppelin-contracts/token/ERC721/utils/ERC721Holder.sol";

import {Balot} from "./Balot.sol";
import {Minter} from "./Minter.sol";

string constant baseURI = "https://example.com/";

contract MinterTest is DSTest, ERC721Holder {
  Balot balot;
  Minter minter;

  function setUp() public {
    balot = new Balot(address(this), baseURI);
    string memory uri0 = "metadata0.json";
    uint256 tokenId0 = balot.safeMint(address(this), uri0);
    assertEq(tokenId0, 0);
    assertEq(balot.tokenURI(tokenId0), string(abi.encodePacked(baseURI, uri0)));
    assertEq(balot.ownerOf(tokenId0), address(this));

    minter = new Minter();
  }

  function testSafeMintAll() public {
    assertEq(balot.owner(), address(this));
    balot.transferOwnership(address(minter));
    assertEq(balot.owner(), address(minter));

    assertEq(balot.ownerOf(0), address(this));
    // TODO: vm expectRevert to check if ownerOf(1) reverts and so on
    address collection = address(balot);
    address nextOwner = address(this);
    address to = address(1337);
    uint16 start = 1;
    uint16 end = 300;
    uint16 step = 1;

    minter.safeMintRange(
      collection,
      nextOwner,
      to,
      start,
      end,
      step
    );
    assertEq(balot.ownerOf(299), address(1337));
    assertEq(balot.ownerOf(300), address(1337));
    //assertEq(balot.ownerOf(301), address(0)); // replace with expect revert

    assertEq(balot.tokenURI(300), string(abi.encodePacked(baseURI, "300.json")));
    // assertEq(balot.tokenURI(300), string(abi.encodePacked(baseURI, "300.json"))); expect revert

    assertEq(balot.owner(), address(nextOwner));
  }
}
