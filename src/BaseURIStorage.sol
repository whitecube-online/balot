// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {ERC721} from "openzeppelin-contracts/token/ERC721/ERC721.sol";

/// @title Adds storage for BaseURI to ERC721
/// @author Tim Daubenschütz
/// @custom:security-contact tim@daubenschuetz.de
abstract contract BaseURIStorage is ERC721 {
  string public baseURI;

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  /// @notice Allows the owner to set all tokens' `_baseURI` value
  /// @param uri The HTTP URL portion that hosts the NFT's metadata.
  function _setBaseURI(
    string memory uri
  ) internal virtual {
    require(bytes(uri).length != 0, "uri empty");
    baseURI = uri;
  }
}
