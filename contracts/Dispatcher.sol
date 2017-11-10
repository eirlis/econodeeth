pragma solidity ^0.4.11;

import "./ownership/Owned.sol";
import "./storage/DataStorage.sol";

contract Dispatcher is Owned {

    mapping (bytes32 => address) contracts;

    function Dispatcher() {
    }

    function setContract(bytes32 name, address _address) onlyOwner {
        if (_address == 0x0) throw;
        contracts[name] = _address;
    }

    function removeContract(bytes32 name) onlyOwner returns (bool result) {
        if (contracts[name] == 0x0) {
            return false;
        }
        contracts[name] = 0x0;
        return true;
    }

    function getContract(bytes32 name) constant returns (address _address) {
        return contracts[name];
    }
}
