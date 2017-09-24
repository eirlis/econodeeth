pragma solidity ^0.4.11;

import "../ownership/Owned.sol";
import "../ownership/Destroyable.sol";
import "../storage/DataStorage.sol";
import "../storage/TrashRequestDAO.sol";
import "../token/TrashToken.sol";
import "../Dispatcher.sol";

contract Warehouse is Owned, Destroyable {

    event BuyTrashEvent(uint256 index, bytes32 hash, uint timestamp, address sender, address receiver, uint256 amount, bytes32 tokenType);
    event TrashEventError(uint when, address sender, address receiver, bytes32 tokenType);
    event RemoveTrashEvent(uint256 index, bytes32 hash,  uint timestamp, address sender, address receiver, uint256 amount, bytes32 tokenType);
    event DealCompleted(uint time, address from, address to, uint256 amount, bytes32 tokenType);
    event DealError(uint time, address from, address to, uint256 amount, bytes32 tokenType);
    event RemoveError(uint time, address from, address to, uint256 amount, bytes32 tokenType);
    event DealCanceledBySender(uint time, address from, address to, uint256 amount, bytes32 tokenType);
    event DealCanceledByReceiver(uint time, address from, address to, uint256 amount, bytes32 tokenType);
	
	using TrashRequestDAO for address;

	Dispatcher public dispatcher;
	mapping (address => mapping (bytes32 => int)) public pricings;
	mapping (address => mapping (bytes32 => bool)) public isAvailable;
	
	function Warehouse (address dispatcherAddress) {
		setDispatcher(dispatcherAddress);
	}

    function setDispatcher(address dispatcherAddress) onlyOwner {
        if (dispatcherAddress == 0x0) throw;
        dispatcher = Dispatcher(dispatcherAddress);
    }

    function setPrice(bytes32 trashType, int price, bool available) {
	pricings[msg.sender][trashType] = price;
	isAvailable[msg.sender][trashType] = available;
    }

    function createTrashRequest(address receiver, uint256 trashAmount, bytes32 tokenType) {
    	if(receiver == 0x0) throw;
    	if(trashAmount == 0) throw;
    	TrashToken token;
    	if(tokenType == "GT") {
    		token = TrashToken(dispatcher.getContract("GlassToken"));
    	} else if(tokenType == "BT") {
    		token = TrashToken(dispatcher.getContract("BatteriesToken"));
    	} else if(tokenType == "CT") {
    		token = TrashToken(dispatcher.getContract("CeramicsToken"));
    	} else if(tokenType == "ChT") {
    		token = TrashToken(dispatcher.getContract("ChemicalsToken"));
    	} else if(tokenType == "MT") {
    		token = TrashToken(dispatcher.getContract("MetalToken"));
    	} else if(tokenType == "MxT") {
    		token = TrashToken(dispatcher.getContract("MixedToken"));
    	} else if(tokenType == "OT") {
    		token = TrashToken(dispatcher.getContract("OrganicalToken"));
    	} else if(tokenType == "PT") {
    		token = TrashToken(dispatcher.getContract("PaperToken"));
    	} else if(tokenType == "PlT") {
    		token = TrashToken(dispatcher.getContract("PlasticToken"));
    	} else if(tokenType == "TT") {
    		token = TrashToken(dispatcher.getContract("TextilesToken"));
    	} 

    	if(token.transferFrom(msg.sender, address(this), trashAmount)) {
    		var (success, fromIndex, hash) = dispatcher.getContract("DataStorage")
    		.addTrashRequest(now, msg.sender, receiver, tokenType, trashAmount);
            if (success) {
                BuyTrashEvent(fromIndex, hash, now, msg.sender, receiver, trashAmount, tokenType);
            } else {
                TrashEventError(now, msg.sender, receiver, tokenType);
                throw; // back coins
            }
        } else {
            TrashEventError(now, msg.sender, receiver, tokenType);
        }
    }

    /*returns: hash, time, sender, receiver, tokenType, amount*/
    function getTrashRequest(uint256 index, bool toMe) returns (bytes32, uint256, address, address, bytes32, uint256) {
    	return dispatcher.getContract("TrashRequestDAO").getTrashRequest(index, toMe);
    }

    function removeTrashRequest(uint256 index, bool toMe, bytes32 _hash) {
    	var (hash, time, from, to, tokenType, amount) = getTrashRequest(index, toMe);
        if (hash != _hash) throw; // protect from double cancel
        if (msg.sender != from && msg.sender != to) throw;
        if (TrashToken(dispatcher.getContract("TrashToken")).transfer(from, amount)) { // send back
            dispatcher.getContract("DataStorage").removeTrashRequest(index, toMe, hash);
            if (toMe) {
                DealCanceledByReceiver(time, from, to, amount, tokenType);
            } else {
                DealCanceledBySender(time, from, to, amount, tokenType);
            }
        } else {
            RemoveError(time, from, to, amount, tokenType);
        }
    }

    function getTrashRequestCount(bool toMe) returns (uint) {
    	return dispatcher.getContract("TrashRequestDAO").getTrashRequestsCount(msg.sender, toMe);
    }

    function() payable {
        if (msg.sender != owner) throw;
    }
}
