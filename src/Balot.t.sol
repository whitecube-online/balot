// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";
import {ERC721Holder} from "openzeppelin-contracts/token/ERC721/utils/ERC721Holder.sol";

import {Balot} from "./Balot.sol";

contract MockCaller {
  function callFrom(address token) public {
      Balot balot = Balot(token);
      string memory uri0 = "https://unauthorized.com";
      balot.safeMint(msg.sender, uri0);
  }

  function setTokenURIFrom(
    address token,
    uint256 tokenId,
    string memory uri
  ) public {
      Balot balot = Balot(token);
      balot.setTokenURI(tokenId, uri);
  }
}

contract BalotTest is DSTest, ERC721Holder {
    Balot balot;
    MockCaller mc;

    function setUp() public {
        balot = new Balot(address(this));
        mc = new MockCaller();
    }

    function testTransferringOwnershipUponInitialization() public {
        Balot nextBalot = new Balot(address(1));
        assertEq(nextBalot.owner(), address(1));
    }

    function testFailSettingTokenURIFromUnauthorizedAccount() public {
      string memory uri0 = "https://example.com/metadata0.json";
      uint256 tokenId0 = balot.safeMint(msg.sender, uri0);
      assertEq(tokenId0, 0);

      assertEq(balot.tokenURI(tokenId0), uri0);
      string memory uri1 = "https://unauthorized.com";
      mc.setTokenURIFrom(address(balot), tokenId0, uri1);
      assertEq(balot.tokenURI(tokenId0), uri0);
    }

    function testSettingTokenURIAsAuthorizedAccount() public {
      string memory uri0 = "https://example.com/metadata0.json";
      uint256 tokenId0 = balot.safeMint(msg.sender, uri0);
      assertEq(tokenId0, 0);

      string memory uri1 = "https://updateddomain.com/metadata0.json";
      assertEq(balot.tokenURI(tokenId0), uri0);
      balot.setTokenURI(tokenId0, uri1);
      assertEq(balot.tokenURI(tokenId0), uri1);
    }

    function testOwnership() public {
      assertEq(balot.owner(), address(this));
    }

    function testRenouncingOwnership() public {
      assertEq(balot.owner(), address(this));
      balot.renounceOwnership();
      assertEq(balot.owner(), address(0));
    }

    function testTransferringOwnership() public {
      assertEq(balot.owner(), address(this));
      balot.transferOwnership(address(1));
      assertEq(balot.owner(), address(1));
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

    function testTransfer() public {
      string memory uri0 = "https://example.com/metadata0.json";
      uint256 tokenId = balot.safeMint(address(this), uri0);
      assertEq(balot.ownerOf(tokenId), address(this));
      balot.transferFrom(address(this), address(1337), tokenId);
      assertEq(balot.ownerOf(tokenId), address(1337));
    }

    function testSupportsInterface() public {
      // NOTE: hash values taken from: https://eips.ethereum.org/EIPS/eip-721
      assertTrue(balot.supportsInterface(0x80ac58cd)); // ERC721
      assertTrue(balot.supportsInterface(0x5b5e139f)); // ERC721Metadata
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

      string memory uri2 = "https://example.com/metadata2.json";
      uint256 tokenId2 = balot.safeMint(address(this), uri2);
      assertEq(tokenId2, 2);
      assertEq(balot.tokenURI(tokenId2), uri2);
      assertEq(balot.ownerOf(tokenId2), address(this));
    }
}
