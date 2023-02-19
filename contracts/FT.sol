// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {

    address internal owner;

    bool internal paused = false;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    function mint(address account, uint256 amount) external {
    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }

    modifier pause(){
        require(paused == false);
        _;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account,amount);
    }

    function burn(uint256 amount) external {

        _burn(msg.sender,amount);
    }

    function transfer(address to,uint amount) public override pause  returns(bool) {
        address from = _msgSender();
        _transfer(from, to, amount);
        return true;
    }
    function changePause(bool newPause) onlyOwner public returns(bool) {
        paused = newPause;
        return true;
    }
}
