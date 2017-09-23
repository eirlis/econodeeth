pragma solidity ^0.4.11;

import "./Owned.sol";

/**
 * @title Common pattern for destroyable contracts
 */
contract Destroyable is Owned {

    address public hammer;

    function Destroyable() {
        hammer = msg.sender;
    }

    /**
     * @dev Hammer setter
     * @param _hammer New hammer address
     */
    function setHammer(address _hammer) onlyOwner {
        if (_hammer == 0x0) throw;
        hammer = _hammer;
    }

    /**
     * @dev Destroy contract and scrub a data
     * @notice Only hammer can call it
     */
    function destroy() onlyHammer {
        selfdestruct(msg.sender);
    }

    /**
     * @dev Hammer check modifier
     */
    modifier onlyHammer { if (msg.sender != hammer) throw; _; }
}