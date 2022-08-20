pragma solidity ^0.8.0;

abstract contract DynamicNftUriGetter {
    function uri(uint256 tokenId) external view virtual returns(string memory) {}
}
