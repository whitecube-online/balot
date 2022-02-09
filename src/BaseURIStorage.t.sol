// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";
import {ERC721} from "openzeppelin-contracts/token/ERC721/ERC721.sol";

import {BaseURIStorage} from "./BaseURIStorage.sol";

contract BaseURIMock is ERC721, BaseURIStorage {
  constructor() ERC721("name", "symbol") {
    _setBaseURI("baseURI");
  }
  function _baseURI() internal override(ERC721, BaseURIStorage) view returns (string memory) {
    return super._baseURI();
  }

  function _setBaseURI(string memory uri) internal override {
    super._setBaseURI(uri);
  }

  function setBaseURI(string memory uri) external {
    _setBaseURI(uri);
  }
}

contract BaseURIStorageTest is DSTest {
  BaseURIMock mock;

    function setUp() public {
      mock = new BaseURIMock();
    }

    function testInitialURL() public {
      assertEq(mock.baseURI(), "baseURI");
    }

    function testSettingBaseURI() public {
      assertEq(mock.baseURI(), "baseURI");
      mock.setBaseURI("new");
      assertEq(mock.baseURI(), "new");
    }

    function testFailSettingEmptyString() public {
      assertEq(mock.baseURI(), "baseURI");
      mock.setBaseURI("");
    }
}
