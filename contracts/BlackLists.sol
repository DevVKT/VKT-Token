// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Blacklist
 * @dev Basic version of StandardToken, with no allowances.
 */
contract Blacklist {
  mapping(address => bool) private lockedList;
  modifier isLocked() { require(!lockedList[msg.sender]); _; }
  modifier isNotLocked() { require(lockedList[msg.sender]); _; }

  function lockAddress(address _villain) public virtual{
    require (!lockedList[_villain]);
    lockedList[_villain] = true;
  }

  function unlockAddress(address _villain) public virtual {
    require (lockedList[_villain]);
    lockedList[_villain] = false;
  }

  function isLockedWallet(address wallet) external view returns (bool) {
      return lockedList[wallet];
  }
}
