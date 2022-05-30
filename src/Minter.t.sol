// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "forge-std/Test.sol";
import {ERC721Holder} from "openzeppelin-contracts/token/ERC721/utils/ERC721Holder.sol";

import {Balot} from "./Balot.sol";
import {Minter} from "./Minter.sol";

contract MockCaller {

  function callSafeMintRangeToSelf(
    address collection,
    uint16 start,
    uint16 end
  ) public {
    Minter minter = Minter(collection);
    minter.safeMintRange(collection, msg.sender, msg.sender, start, end);
  }

  function callTransferCollection(address collection, address nextOwner) public {
    Minter minter = Minter(collection);
    minter.transferCollection(collection, nextOwner);
  }
}


string constant baseURI = "https://example.com/";

contract MinterTest is Test, ERC721Holder {
  Balot balot;
  Minter minter;
  MockCaller mc;

  function setUp() public {
    balot = new Balot(address(this), baseURI);
    string memory uri0 = "metadata0.json";
    uint256 tokenId0 = balot.safeMint(address(this), uri0);
    assertEq(tokenId0, 0);
    assertEq(balot.tokenURI(tokenId0), string(abi.encodePacked(baseURI, uri0)));
    assertEq(balot.ownerOf(tokenId0), address(this));

    minter = new Minter();

    mc = new MockCaller();
  }

  function testRunSafeMint() public {
    balot.transferOwnership(address(minter));

    address collection = address(balot);
    address nextOwner = address(this);
    address to = address(1337);
    uint16 start = 1;
    uint16 end = 300;

    minter.safeMintRange(
      collection,
      nextOwner,
      to,
      start,
      end
    );
  }

  function testUnauthorizedRangeMint() public {
    balot.transferOwnership(address(minter));

    address collection = address(balot);
    uint16 start = 1;
    uint16 end = 300;

    vm.expectRevert();
    mc.callSafeMintRangeToSelf(
      collection,
      start,
      end
    );
  }

  function testSafeMintAll() public {
    assertEq(balot.owner(), address(this));
    balot.transferOwnership(address(minter));
    assertEq(balot.owner(), address(minter));

    assertEq(balot.ownerOf(0), address(this));
    vm.expectRevert(bytes("ERC721: owner query for nonexistent token"));
    balot.ownerOf(1);
    address collection = address(balot);
    address nextOwner = address(this);
    address to = address(1337);
    uint16 start = 1;
    uint16 end = 300;

    minter.safeMintRange(
      collection,
      nextOwner,
      to,
      start,
      end
    );
    assertEq(balot.ownerOf(299), address(1337));
    assertEq(balot.ownerOf(300), address(1337));
    vm.expectRevert(bytes("ERC721: owner query for nonexistent token"));
    balot.ownerOf(301);

    assertEq(balot.tokenURI(300), string(abi.encodePacked(baseURI, "300.json")));
    vm.expectRevert(bytes("ERC721URIStorage: URI query for nonexistent token"));
    balot.tokenURI(301);

    assertEq(balot.owner(), address(nextOwner));
  }

  function testTransferCollection() public {
    balot.transferOwnership(address(minter));
    minter.transferCollection(address(balot), address(this));
    
    assertEq(balot.owner(), address(this));
  }

  function testUnauthorizedTransferCollection() public {
    balot.transferOwnership(address(minter));
    address nextOwner = address(this);

    vm.expectRevert();
    mc.callTransferCollection(
      address(balot), nextOwner
    );
  }
}