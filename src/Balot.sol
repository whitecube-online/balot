// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {ERC721} from "openzeppelin-contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";
import {Counters} from "openzeppelin-contracts/utils/Counters.sol";

/// @title Balot is an NFT collection
/// @author Tim Daubenschütz
/// @custom:security-contact tim@daubenschuetz.de
contract Balot is ERC721, ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  /// @notice Upon initialization, ownership of the contract is immediately transferred
  /// @param nextOwner The address the contract ownership is transferred to
  constructor(address nextOwner) ERC721("Balot", "BALOT") {
    transferOwnership(nextOwner);
  }

  /// @notice Allows the owner to safely mint an NFT to an address and given a `uri`
  /// @dev Requires ownership of the contract
  /// @param to The address that should own the NFT
  /// @param uri The HTTP URL that hosts the NFT's metadata.json
  /// @return tokenId The identifier uniquely defining the token
  function safeMint(
    address to,
    string memory uri
  ) external onlyOwner returns (uint256) {
    uint256 newTokenId = _tokenIds.current();
    _safeMint(to, newTokenId);
    _setTokenURI(newTokenId, uri);
    _tokenIds.increment();
    return newTokenId;
  }

  /// @notice Allows the owner to set each `tokenId`'s `uri`
  /// @dev Requires ownership of the contract
  /// @param tokenId The id of the token to change
  /// @param uri The HTTP URL that hosts the NFT's metadata.json
  function setTokenURI(
    uint256 tokenId,
    string memory uri
  ) onlyOwner external {
    _setTokenURI(tokenId, uri);
  }

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }

  function tokenURI(
    uint256 tokenId
  ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    return super.tokenURI(tokenId);
  }
}
