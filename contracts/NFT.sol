// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    address immutable public owner;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    uint[] private tokens;
    mapping(uint256 => uint256) private accountTokenIdToIndex;
    mapping(uint256 => uint256) private allTokenIdToIndex;
    mapping(address => mapping(uint256 => uint256)) private accountToIndexToToken;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = msg.sender;
    }

    function mint(address account, uint256 tokenId) external {
    function mint(address account, uint256 tokenId) onlyOwner external {
        // TODO
        uint256 length = balanceOf(account);
        accountToIndexToToken[account][length] = tokenId;
        accountTokenIdToIndex[tokenId] = length;
        allTokenIdToIndex[tokenId] = tokens.length;
        tokens.push(tokenId);
        _mint(account, tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(ownerOf(tokenId) == msg.sender,"owner");

        uint deletoken = accountTokenIdToIndex[tokenId];
        uint lasttoken = balanceOf(msg.sender) - 1;
        if(deletoken != lasttoken){
            uint val = accountToIndexToToken[msg.sender][lasttoken];
            accountToIndexToToken[msg.sender][deletoken] = val;
            accountTokenIdToIndex[val] = deletoken;
        }
        delete accountTokenIdToIndex[tokenId];
        delete accountToIndexToToken[msg.sender][lasttoken];

        uint deleIndex = allTokenIdToIndex[tokenId];
        uint lastIndex = tokens.length - 1;
        tokens[deleIndex] = tokens[lastIndex];
        allTokenIdToIndex[tokens[lastIndex]] = deleIndex;
        delete allTokenIdToIndex[tokenId];
        tokens.pop();
        _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return tokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return accountToIndexToToken[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return tokens[index];
    }
}
