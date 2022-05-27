// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {Strings} from "openzeppelin-contracts/utils/Strings.sol";

interface Balot {
  function safeMint(address to, string calldata uri) external returns (uint256);
  function transferOwnership(address newOwner) external;
}

contract Minter {
  function safeMintRange(
    address collection,
    address nextOwner,
    address to,
    uint16 start,
    uint16 end,
    uint16 step
  ) external {
    Balot b = Balot(collection);
    for (uint256 tokenId = start; tokenId <= end; tokenId += step) {
      b.safeMint(to, string(abi.encodePacked(
        Strings.toString(tokenId),
        ".json"
      )));
    }
    b.transferOwnership(nextOwner);
  }
}
