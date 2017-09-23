pragma solidity ^0.4.11;

import "../ownership/Owned.sol";
import "../ownership/Destroyable.sol";
import "../storage/DataStorage.sol";
import "../storage/TrashRequestDAO.sol";
import "../token/TrashToken.sol";
import "../Dispatcher.sol";


contract Warehouse is Owned, Destroyable {

	event BuyTrashEvent(uint256 index, bytes32 hash, address sender, address receiver, uint timestamp);

	event TrashEventError(uint when, address sender, address receiver);

	event RemoveTrashEvent(uint256 index, bytes32 hash, address sender, address receiver, uint timestamp);

	event DealCompleted(uint time, address from, address to, uint256 amount);

    event DealError(uint time, address from, address to, uint256 amount);

    event RemoveError(uint time, address from, address to, uint256 amount);

    event DealCanceledBySender(uint time, address from, address to, uint256 amount);

    event DealCanceledByReceiver(uint time, address from, address to, uint256 amount);

	
	using TrashRequestDAO for address;

	Dispatcher public dispatcher;

	mapping (address => mapping (string => int)) pricings;

	mapping (address => mapping (string => bool)) isAvailable;
	

	function Warehouse (address dispatcherAddress) {
		setDispatcher(dispatcherAddress);
	}

	function setDispatcher(address dispatcherAddress) onlyOwner {
        if (dispatcherAddress == 0x0) throw;
        dispatcher = Dispatcher(dispatcherAddress);
    }

    function createTrash(address receiver, uint256 trashAmount, string type) {
    	if(receiver == 0x0) throw;
    	if(trashAmount == 0) throw;
    	TrashToken token;
    	if(type == "GT") {
    		token = TrashToken(dispatcher.getContract("GlassToken");
    	} else if(type == "BT") {
    		token = TrashToken(dispatcher.getContract("BatteriesToken");
    	} else if(type == "CT") {
    		token = TrashToken(dispatcher.getContract("CeramicsToken");
    	} else if(type == "ChT") {
    		token = TrashToken(dispatcher.getContract("ChemicalsToken");
    	} else if(type == "MT") {
    		token = TrashToken(dispatcher.getContract("MetalToken");
    	} else if(type == "MxT") {
    		token = TrashToken(dispatcher.getContract("MixedToken");
    	} else if(type == "OT") {
    		token = TrashToken(dispatcher.getContract("OrganicalToken");
    	} else if(type == "PT") {
    		token = TrashToken(dispatcher.getContract("PaperToken");
    	} else if(type == "PlT") {
    		token = TrashToken(dispatcher.getContract("PlasticToken");
    	} else if(type == "TT") {
    		token = TrashToken(dispatcher.getContract("TextilesToken");
    	}



    	if(token.transferFrom(msg.sender, address(this), amount))) {
    		var (success, fromIndex, hash) = dispatcher.getContract("DataStorage")
    		.addTrashRequest(now, msg.sender, receiver, trashAmount);
            if (success) {
                BuyTrashEvent(fromIndex, hash, now, msg.sender, receiver, amount);
            } else {
                TrashEventError(now, msg.sender, receiver);
                throw; // back coins
            }
        } else {
            TrashEventError(now, msg.sender, receiver);
        }


    }

    /*returns: hash, time, sender, receiver, type, amount*/
    function getTrash(uint256 index, bool toMe) returns (bytes32, uint256, address, address, string, uint) {
    	return dispatcher.getContract("TrashRequestDAO").getTrashRequest(index, toMe);
    }

    function removeTrash(uint256 index, bool toMe, bytes32 hash) {
    	var (hash, time, from, to, type, amount) = getTrash(index, toMe);
        if (hash != _hash) throw; // protect from double cancel
        if (msg.sender != from && msg.sender != to) throw;
        if (TrashToken(dispatcher.getContract("TrashToken")).transfer(from, amount)) { // send back
            dispatcher.getContract("DataStorage").removeTrashRequest(index, toMe, hash);
            if (toMe) {
                DealCanceledByReceiver(time, from, to, amount);
            } else {
                DealCanceledBySender(time, from, to, amount);
            }
        } else {
            CancelError(time, from, to, amount);
        }

    }

    function trashCount(bool toMe) returns (uint) {
    	return dispatcher.getContract("TrashRequestDAO").getTrashRequestsCount(toMe);
    }

    function() payable {
        if (msg.sender != owner) throw;
    }
}
