//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "./DynamicNftUriGetter.sol";

contract DynamicNFTs is ERC1155Burnable, Ownable {
    constructor(string memory contractUri) ERC1155("") {
        _contractURI = contractUri;
    }

    string public _contractURI;

    function setContractURI(string memory contractUri) external onlyOwner() {
        _contractURI = contractUri;
    }

    function contractURI() external view virtual returns (string memory) {
        return _contractURI;
    }

    mapping(uint256 => address) public uriGeneratorAddresses;
    function mint(uint256 tokenId, uint256 amount, address uriGeneratorAddress) external onlyOwner() {
        _mint(_msgSender(), tokenId, amount, "");
        uriGeneratorAddresses[tokenId] = uriGeneratorAddress;
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return DynamicNftUriGetter(uriGeneratorAddresses[tokenId]).uri(tokenId);
    }
}