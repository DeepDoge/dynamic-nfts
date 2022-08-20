//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DynamicNftUriGetter.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../utils/Base64.sol";

contract BlockchainPolygon is DynamicNftUriGetter {
    using Strings for uint256;
    using Strings for uint128;

    constructor() {
    }

    function _attributes(string memory blockNumberString) private pure returns(string memory) {
        return string(
            abi.encodePacked(
                '[',
                    '{"trait_type":"Block Number","value":"',blockNumberString,'"}'
                ']'
            )
        );
    }

    function _point(bytes32 seed) private pure returns(string memory) {
        bytes16[2] memory xy = [bytes16(0), 0];
        assembly {
            mstore(xy, seed)
            mstore(add(xy, 16), seed)
        }
        
        return string(
            abi.encodePacked(
                (uint128(xy[0]) % 2048).toString(),",",(uint128(xy[1]) % 2048).toString()," "
            )
        );
    }

    function _svg() private view returns(string memory) {
        string memory points = "";

        for (uint256 i = 16; i > 0;)
            points = string(
                abi.encodePacked(
                    points,
                    _point(blockhash(block.number - i--)),
                    _point(blockhash(block.number - i--)),
                    _point(blockhash(block.number - i--)),
                    _point(blockhash(block.number - i--)),
                    _point(blockhash(block.number - i--)),
                    _point(blockhash(block.number - i--)),
                    _point(blockhash(block.number - i--)),
                    _point(blockhash(block.number - i--))
                )
            );


        return string(
            abi.encodePacked(
                "<svg width='2048' height='2048' viewPort='0 0 2048 2048' style='background:#181a21' xmlns='http://www.w3.org/2000/svg'>",
                "<polygon filter='url(#f)' points='",points,"' style='fill:none;stroke:#8247e5;stroke-width:50'/>",
                "<defs><filter id='f' width='200%' height='200%'><feGaussianBlur result='blurOut' in='offOut' stdDeviation='50'/><feBlend in='SourceGraphic' in2='blurOut' mode='normal'/></filter></defs>",
                "</svg>"
            )
        );
    }

    function uri(uint256) public view override returns (string memory) {
        string memory blockNumberString = block.number.toString();
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(string(abi.encodePacked(
                        '{"name":"Blockchain Polygon",', 
                        '"description":"A dynamic NFT, changing dynamically based on the 16 most recent blocks on the chain.\\n',
                            'Every point of this polygon representing a block, positioned based on the block hash.\\n\\n',
                            'All of the item metadata of this NFT lives on the blockchain.",',  
                        '"image_data":', '"', _svg(), '",',
                        '"attributes":', _attributes(blockNumberString), 
                        '}')))
                )
            );
    }
}