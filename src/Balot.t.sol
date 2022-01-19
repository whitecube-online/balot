// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import {Balot} from "./Balot.sol";

contract BalotTest is DSTest {
    Balot balot;

    function setUp() public {
        balot = new Balot();
    }

    function testGetName() public {
      assertEq(balot.name(), "Balot");
    }
}
