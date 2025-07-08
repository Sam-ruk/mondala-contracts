pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Utils.sol"; 

contract Mondala is ERC721 {
    uint256 public constant PRICE = 0.001 ether;
    uint256 private _nextTokenId;
    mapping(uint256 => string) private _tokenSVGs;

    constructor() ERC721("Mondala", "SVG") {}

    function safeMint(address to, string memory svgData) public payable {
        require(msg.value >= PRICE, "Insufficient funds");

        uint256 tokenId = _nextTokenId++;
        _tokenSVGs[tokenId] = svgData;
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory svg = _tokenSVGs[tokenId];
        string memory imageData = string(abi.encodePacked("data:image/svg+xml;base64,", Utils.encode(bytes(svg))));
        string memory json = string(abi.encodePacked(
            '{"name":"Mondala #', Utils.toString(tokenId), '","description":"On-chain SVG Mandala design.","image":"', imageData, '"}'
        ));
        return string(abi.encodePacked("data:application/json;base64,", Utils.encode(bytes(json))));
    }
}