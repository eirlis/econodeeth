pragma solidity ^0.4.11;

import "./Owned.sol";
import "../Dispatcher.sol";

contract AccessManager is Owned {

    uint8 public version = 1;

    Dispatcher public dispatcher;

    function AccessManager(address dispatcherAddress) {
        setDispatcher(dispatcherAddress);
    }

    function setDispatcher(address dispatcherAddress) onlyOwner {
        if (dispatcherAddress == 0x0) throw;
        dispatcher = Dispatcher(dispatcherAddress);
    }

    function checkStorageAccess(address _address) constant returns (bool) {
        if (_address == 0x0) return false;
        return _address == dispatcher.getContract("Warehouse");
    }
}
