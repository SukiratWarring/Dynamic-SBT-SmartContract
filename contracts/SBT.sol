// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SBT is ERC721, Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter public tokenIDs;
    mapping(uint256 => string) public idToTokenUri;

    event Attest(address indexed _to, uint256 indexed tokenId);
    event Revoke(address indexed _to, uint256 indexed tokenId);

    constructor() ERC721("JuneoNft", "JFT") {}

    function safeMint(address to, string memory uri) public {
        uint256 tokenidTemp = tokenIDs.current();
        tokenIDs.increment();
        _safeMint(to, tokenidTemp);
        _setTokenURI(tokenidTemp, uri);
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory uri
    ) internal virtual override {
        idToTokenUri[tokenId] = uri;
    }

    function changeTokenUri(
        uint256 tokenId,
        string memory uri
    ) external onlyOwner {
        _setTokenURI(tokenId, uri);
    }

    function burn(uint256 tokenId) external {
        require(
            ownerOf(tokenId) == msg.sender,
            "Only the owner can burn the Contract"
        );
        _burn(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 /* tokenId */,
        uint256 /* batchSize */
    ) internal virtual override {
        require(
            from == address(0) || to == address(0),
            "Cannot transfer this Asset As this is an SBT Token"
        );
    }

    function _afterTokenTransfer(
        address /* from */,
        address to,
        uint256 tokenId,
        uint256 /*batchSize*/
    ) internal virtual override {
        emit Attest(to, tokenId);
        emit Revoke(to, tokenId);
    }

    //Mandatory for Solidity
    function _burn(
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    )
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return idToTokenUri[tokenId];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
