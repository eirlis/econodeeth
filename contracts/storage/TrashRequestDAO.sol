pragma solidity ^0.4.11;

import "./DataStorage.sol";

library TrashRequestDAO {

    function version() constant returns (uint8) {
        return 1;
    }

    function getAllTrashRequestsCount(address _storageContract) constant returns (uint256) {
        if (_storageContract == 0x0) throw;
        return DataStorage(_storageContract).getUIntValue(sha3("TrashRequestCount"));
    }

    function getTrashRequestsCount(address _storageContract, address participant, bool toMe) constant returns (uint256) {
        if (_storageContract == 0x0) throw;
	if (participant == 0x0) throw;
	if (toMe) {
        	return DataStorage(_storageContract).getUIntValue(sha3("ToTrashRequestCount", participant));
	} else {
		return DataStorage(_storageContract).getUIntValue(sha3("FromTrashRequestCount", participant));
	}
    }

    function addTrashRequest(address _storageContract, uint time, address sender, address receiver, string trashType, uint256 amount) returns (bool success, uint256 index, bytes32 hash) {
        if (_storageContract == 0x0) throw;
        if (time == 0) throw;
	if (sender == 0x0) throw;
        if (receiver == 0x0) throw;
        if (amount == 0) throw;
        fromIndex = DataStorage(_storageContract).getUIntValue(sha3("TrashRequestFromIndex", sender));
        hash = sha3(fromIndex, time, sender, receiver, trashType, amount);
        uint256 toIndex = DataStorage(_storageContract).getUIntValue(sha3("TrashRequestToIndex", receiver));
	setTrashRequest(_storageContract, hash, time, sender, receiver, trashType, amount, fromIndex, toIndex);
        DataStorage(_storageContract).setBytes32Value(sha3("TrashRequestIndexesFrom", sender, fromIndex), hash);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestFromIndex", sender), fromIndex + 1);
        DataStorage(_storageContract).setBytes32Value(sha3("TrashRequestIndexesTo", receiver, toIndex), hash);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestToIndex", receiver), toIndex + 1);
        incrementCounts(_storageContract, sender, receiver);
        success = true;
    }

    function removeTrashRequest(address _storageContract, uint256 _id, bool toMe, bytes32 _hash) {
        if (_storageContract == 0x0) throw;
	bytes32 hash = getTrashRequestHashIndex(_storageContract, _id, toMe); // get hash-index to offer object
        if (hash != _hash) throw; // protect from double remove
	address from = DataStorage(_storageContract).getAddressValue(sha3("trash_request_from", hash));
        address to = DataStorage(_storageContract).getAddressValue(sha3("trash_request_to", hash));
        uint256 fromIndex = DataStorage(_storageContract).getUIntValue(sha3("TrashRequestFromIndex", from)) - 1;
        uint256 toIndex = DataStorage(_storageContract).getUIntValue(sha3("TrashRequestToIndex", to)) - 1;
        // get last hash-indexes
        bytes32 hFrom = DataStorage(_storageContract).getBytes32Value(sha3("TrashRequestIndexesFrom", from, fromIndex));
        bytes32 hTo = DataStorage(_storageContract).getBytes32Value(sha3("TrashRequestIndexesTo", to, toIndex));
        // set last hash-indexes instead removable
        if (toMe) {
            DataStorage(_storageContract).setBytes32Value(sha3("TrashRequestIndexesTo", to, _id), hTo);
            uint256 offerFromIndex = DataStorage(_storageContract).getUIntValue(sha3("trash_request_from_index", hash));
            DataStorage(_storageContract).setBytes32Value(sha3("TrashRequestIndexesFrom", from, offerFromIndex), hFrom);
        } else {
            DataStorage(_storageContract).setBytes32Value(sha3("TrashRequestIndexesFrom", from, _id), hFrom);
            uint256 offerToIndex = DataStorage(_storageContract).getUIntValue(sha3("trash_request_to_index", hash));
            DataStorage(_storageContract).setBytes32Value(sha3("TrashRequestIndexesTo", to, offerToIndex), hTo);
        }
        // delete last hash-indexes
        DataStorage(_storageContract).deleteBytes32Value(sha3("TrashRequestIndexesFrom", from, fromIndex));
        DataStorage(_storageContract).deleteBytes32Value(sha3("TrashRequestIndexesTo", to, toIndex));
        // delete offer object
        deleteTrashRequest(_storageContract, hash);
        // save decrement count and indexes
        decrementCounts(_storageContract, from, to);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestFromIndex", from), fromIndex);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestToIndex", to), toIndex);
    }

    function setTrashRequest(address _storageContract, bytes32 hash, uint time, address sender, address receiver, string trashType, uint256 amount, uint256 fromIndex, uint256 toIndex) private {
        DataStorage(_storageContract).setUIntValue(sha3("trash_request_time", hash), time);
	DataStorage(_storageContract).setAddressValue(sha3("trash_request_sender", hash), sender);
        DataStorage(_storageContract).setAddressValue(sha3("trash_request_receiver", hash), receiver);
        DataStorage(_storageContract).setStringValue(sha3("trash_request_type", hash), trashType);
        DataStorage(_storageContract).setUIntValue(sha3("trash_request_amount", hash), amount);
	DataStorage(_storageContract).setUIntValue(sha3("trash_request_from_index", hash), fromIndex);
        DataStorage(_storageContract).setUIntValue(sha3("trash_request_to_index", hash), toIndex);
    }

    function getTrashRequest(address _storageContract, uint256 _id, bool toMe) constant returns (bytes32 hash, uint time, address sender, address receiver, string trashType, uint256 amount) {
        if (_storageContract == 0x0) throw;
        hash = getTrashRequestHashIndex(_storageContract, _id, toMe);
        time = DataStorage(_storageContract).getUIntValue(sha3("trash_request_time", hash));
	sender = DataStorage(_storageContract).getAddressValue(sha3("trash_request_sender", hash));
        receiver = DataStorage(_storageContract).getAddressValue(sha3("trash_request_receiver", hash));
        trashType = DataStorage(_storageContract).getStringValue(sha3("trash_request_type", hash));
        amount = DataStorage(_storageContract).getUIntValue(sha3("trash_request_amount", hash));
    }

    function deleteTrashRequest(address _storageContract, bytes32 hash) private {
        DataStorage(_storageContract).deleteUIntValue(sha3("trash_request_time", hash));
	DataStorage(_storageContract).deleteAddressValue(sha3("trash_request_sender", hash));
        DataStorage(_storageContract).deleteAddressValue(sha3("trash_request_receiver", hash));
        DataStorage(_storageContract).deleteStringValue(sha3("trash_request_type", hash));
        DataStorage(_storageContract).deleteUIntValue(sha3("trash_request_amount", hash));
	DataStorage(_storageContract).deleteUIntValue(sha3("trash_request_from_index", hash));
	DataStorage(_storageContract).deleteUIntValue(sha3("trash_request_to_index", hash));
    }

    function getTrashRequestHashIndex(address _storageContract, uint256 _id, bool toMe) private returns (bytes32 hash) {
        if (toMe) {
            hash = DataStorage(_storageContract).getBytes32Value(sha3("TrashRequestIndexesTo", msg.sender, _id));
        } else {
            hash = DataStorage(_storageContract).getBytes32Value(sha3("TrashRequestIndexesFrom", msg.sender, _id));
        }
    }

    function incrementCounts(address _storageContract, address sender, address receiver) private {
        uint256 count = getAllTrashRequestsCount(_storageContract);
        uint256 fromCount = getTrashRequestsCount(_storageContract, sender, false);
        uint256 toCount = getTrashRequestsCount(_storageContract, receiver, true);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestCount"), count + 1);
        DataStorage(_storageContract).setUIntValue(sha3("FromTrashRequestCount", sender), fromCount + 1);
        DataStorage(_storageContract).setUIntValue(sha3("ToTrashRequestCount", receiver), toCount + 1);
    }

    function decrementCounts(address _storageContract, address sender, address receiver) private {
        uint256 count = getAllTrashRequestsCount(_storageContract);
        uint256 fromCount = getTrashRequestsCount(_storageContract, sender, false);
        uint256 toCount = getTrashRequestsCount(_storageContract, receiver, true);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestCount"), count - 1);
        DataStorage(_storageContract).setUIntValue(sha3("FromTrashRequestCount", sender), fromCount - 1);
        DataStorage(_storageContract).setUIntValue(sha3("ToTrashRequestCount", receiver), toCount - 1);
    }
}
