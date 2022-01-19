// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import {Balot} from "./Balot.sol";

contract MockCaller {
  function callFrom(address token) public {
      Balot balot = Balot(token);
      string memory uri0 = "https://unauthorized.com";
      balot.safeMint(msg.sender, uri0);
  }
}

contract BalotTest is DSTest {
    Balot balot;
    MockCaller mc;

    function setUp() public {
        balot = new Balot();
        mc = new MockCaller();
    }

    function testCollectionData() public {
      assertEq(balot.name(), "Balot");
      assertEq(balot.symbol(), "BALOT");
    }

    function testFailMintingFromUnauthorizedAddress() public {
      // NOTE: We want to make sure that mc.callFrom fails
      mc.callFrom(address(balot));

      // NOTE: We also want to make sure that no token was minted
      string memory uri0 = "https://example.com/metadata0.json";
      uint256 tokenId0 = balot.safeMint(msg.sender, uri0);
      assertEq(tokenId0, 0);
    }

    function testSafeMint() public {
      string memory uri0 = "https://example.com/metadata0.json";
      uint256 tokenId0 = balot.safeMint(msg.sender, uri0);
      assertEq(tokenId0, 0);
      assertEq(balot.tokenURI(tokenId0), uri0);
      assertEq(balot.tokenURI(tokenId0), uri0);
      assertEq(balot.ownerOf(tokenId0), msg.sender);

      string memory uri1 = "https://example.com/metadata1.json";
      uint256 tokenId1 = balot.safeMint(msg.sender, uri1);
      assertEq(tokenId1, 1);
      assertEq(balot.tokenURI(tokenId1), uri1);
      assertEq(balot.ownerOf(tokenId1), msg.sender);
    }
}
