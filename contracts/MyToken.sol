// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./HitchensUnorderedKeySet.sol";

contract MyToken is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using HitchensUnorderedKeySetLib for HitchensUnorderedKeySetLib.Set;

    Counters.Counter private _tokenIdCounter;
    mapping(address => HitchensUnorderedKeySetLib.Set) private operatorApprovals;

    constructor() ERC721("MyToken", "MTK") {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function getApprovedOperators(address owner) public view returns (address[] memory)  {
        uint count = operatorApprovals[owner].count();
        address[] memory operators = new address[](count);

        for (uint i = 0; i < count; i++) {
            operators[i] = operatorApprovals[owner].keyAtIndex(i);
        }

        return operators;
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        address owner  = _msgSender();
        require(owner != operator, "ERC721: approve to caller");

        if (approved) {
            operatorApprovals[owner].insert(operator);
        } else {
            operatorApprovals[owner].remove(operator);
        }

        _setApprovalForAll(owner, operator, approved);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
