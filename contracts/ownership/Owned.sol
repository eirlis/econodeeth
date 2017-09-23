pragma solidity ^0.4.11;

/**
 * @title Contract for object that have an owner
 */
contract Owned {

    /**
     * Contract owner address
     */
    address public owner;

    function Owned() {
        owner = msg.sender;
    }

    /**
     * @dev Delegate contract to another person
     * @param _owner New owner address
     */
    function setOwner(address _owner) onlyOwner {
        if (_owner == 0x0) throw;
        owner = _owner;
    }

    /**
     * @dev Owner check modifier
     */
    modifier onlyOwner { if (msg.sender != owner) throw; _; }
}