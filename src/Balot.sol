// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {ERC721} from "openzeppelin-contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";
import {Counters} from "openzeppelin-contracts/utils/Counters.sol";

import {BaseURIStorage} from "./BaseURIStorage.sol";

/// @title Balot is an NFT collection
/// @author Tim Daubenschütz
/// @custom:security-contact tim@daubenschuetz.de
contract Balot is ERC721, ERC721URIStorage, Ownable, BaseURIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  /// @notice Upon initialization, ownership of the contract is immediately transferred
  /// @param nextOwner The address the contract ownership is transferred to
  /// @param uri The `baseURI` that is used to construct the final `tokenURI`
  constructor(address nextOwner, string memory uri) ERC721("Balot", "BALOT") {
    transferOwnership(nextOwner);
    _setBaseURI(uri);
  }

  /// @notice Overrides ERC721's `_baseURI` function such that `tokenURI` start using it
  function _baseURI() internal view override(ERC721, BaseURIStorage) returns (string memory) {
    return super._baseURI();
  }

  /// @notice Allows the owner to set all tokens' `_baseURI` value
  /// @param uri The HTTP URL portion that hosts the NFT's metadata.
  function setBaseURI(
    string calldata uri
  ) external onlyOwner {
    super._setBaseURI(uri);
  }

  /// @notice Allows the owner to safely mint an NFT to an address and given a `uri`
  /// @dev Requires ownership of the contract
  /// @param to The address that owns the NFT
  /// @param uri The path portion of an URL that specifies the location of the metadata
  function safeMint(
    address to,
    string calldata uri
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
    string calldata uri
  ) external onlyOwner {
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
