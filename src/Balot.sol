// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {ERC721} from "openzeppelin-contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";
import {Counters} from "openzeppelin-contracts/utils/Counters.sol";

/// @title Balot is an NFT collection
/// @author Tim Daubenschütz
contract Balot is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Balot", "BALOT") {}

  /// @notice Safely mints an NFT to an address and given a `tokenURI`
  /// @dev Requires ownership of the contract
  /// @param to The address that should own the NFT
  /// @param tokenURI The HTTP URL that hosts the NFT's metadata.json
  /// @return tokenId The identifier uniquely defining the token
  function safeMint(
    address to,
    string memory tokenURI
  ) external onlyOwner returns (uint256) {
    uint256 newTokenId = _tokenIds.current();
    _safeMint(to, newTokenId);
    _setTokenURI(newTokenId, tokenURI);

    _tokenIds.increment();
    return newTokenId;
  }
}
