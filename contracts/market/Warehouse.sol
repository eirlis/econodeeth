pragma solidity ^0.4.11;

import "../ownership/Owned.sol";
import "../storage/DataStorage.sol";
import "../storage/TrashRequestDAO.sol";
import "../token/TrashToken.sol";
import "../Dispatcher.sol";


contract Warehouse is Owned {

	event BuyTrashEvent(uint256 index, bytes32 hash, address sender, address receiver, uint timestamp);

	event CancelTrashEvent(address victim);
	
	
	

	using TrashRequestDAO for address;

	Dispatcher public dispatcher;

	mapping (address => mapping (string => uint)) appliers;

	mapping (address => mapping (string => int)) pricings;

	mapping (address => mapping (string => bool)) isAvailable;
	

	function Warehouse (address dispatcherAddress) {
		setDispatcher(dispatcherAddress);
	}

	function setDispatcher(address dispatcherAddress) onlyOwner {
        if (dispatcherAddress == 0x0) throw;
        dispatcher = Dispatcher(dispatcherAddress);
    }

    function applyTrashRequest(uint trashAmount) {
    	if(trashAmount == 0) throw;

    }

    /*returns: hash, time, sender, receiver, type, amount*/
    function getTrash() returns (bytes32, uint256, address, address, string, uint)

    function trashRequestsCount() returns (uint) {

    }

}
