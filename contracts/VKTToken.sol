// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

import "./MintableToken.sol";
import "./BlackLists.sol";

contract VKTToken is ERC20, ERC20Burnable, Pausable, MintableToken, AccessControl, Blacklist, ERC20Permit {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    constructor() ERC20("VirtualK-Pop", "VKT") ERC20Permit("VirtualK-Pop") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(OPERATOR_ROLE, msg.sender);
        _mint(msg.sender, 20000000000 * 10 ** decimals());
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) canMint {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function transfer(address _to, uint256 _value) public isLocked override returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public isLocked override returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function lockAddress(address _villain) public onlyRole(OPERATOR_ROLE) override {
        super.lockAddress(_villain);
    }

    function unlockAddress(address _villain) public onlyRole(OPERATOR_ROLE) override {
        super.unlockAddress(_villain);
    }

    function resumeMinting() public cantMint onlyRole(MINTER_ROLE) override returns (bool) {
        super.resumeMinting();
        return true;
    }

    function finishMinting() public canMint onlyRole(MINTER_ROLE) override returns (bool) {
        super.finishMinting();
        return true;
    }
}