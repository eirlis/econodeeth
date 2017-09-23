pragma solidity ^0.4.11;

import "./DataStorage.sol";

library TrashRequestDAO {

    function version() constant returns (uint8) {
        return 1;
    }

    function getTrashRequestsCount(address _storageContract) constant returns (uint256) {
        if (_storageContract == 0x0) throw;
        return DataStorage(_storageContract).getUIntValue(sha3("TrashRequestCount"));
    }

    function addTrashRequest(address _storageContract, uint time, address sender, address receiver, string trashType, uint256 amount) returns (bool success, uint256 index, bytes32 hash) {
        if (_storageContract == 0x0) throw;
        if (time == 0) throw;
	if (sender == 0x0) throw;
        if (receiver == 0x0) throw;
        if (amount == 0) throw;
        index = DataStorage(_storageContract).getUIntValue(sha3("TrashRequestIndex"));
        hash = sha3(index, time, sender, receiver, trashType, amount);
        setTrashRequest(_storageContract, hash, index, time, sender, receiver, trashType, amount);
        uint256 count = getTrashRequestsCount(_storageContract);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestCount"), count + 1);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestIndex"), index + 1);
        success = true;
    }

    function removeTrashRequest(address _storageContract, uint256 _id, bytes32 _hash) {
        if (_storageContract == 0x0) throw;
        var (hash,,,,,) = getTrashRequest(_storageContract, _id);
        if (hash != _hash) throw; // protect from double remove
        uint256 lastIndex = DataStorage(_storageContract).getUIntValue(sha3("TrashRequestIndex")) - 1;
        copyTrashRequest(_storageContract, lastIndex, _id);
        uint256 count = getTrashRequestsCount(_storageContract);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestCount"), count - 1);
        DataStorage(_storageContract).setUIntValue(sha3("TrashRequestIndex"), lastIndex);
        deleteTrashRequest(_storageContract, lastIndex);
    }

    function copyTrashRequest(address _storageContract, uint256 fromIndex, uint256 toIndex) private {
        var (hash, time, sender, receiver, trashType, amount) = getTrashRequest(_storageContract, fromIndex);
        setTrashRequest(_storageContract, hash, toIndex, time, sender, receiver, trashType, amount);
    }

    function setTrashRequest(address _storageContract, bytes32 hash, uint256 _id, uint time, address sender, address receiver, string trashType, uint256 amount) private {
        DataStorage(_storageContract).setBytes32Value(sha3("trash_request_hash", _id), hash);
        DataStorage(_storageContract).setUIntValue(sha3("trash_request_time", _id), time);
	DataStorage(_storageContract).setAddressValue(sha3("trash_request_sender", _id), sender);
        DataStorage(_storageContract).setAddressValue(sha3("trash_request_receiver", _id), receiver);
        DataStorage(_storageContract).setStringValue(sha3("trash_request_type", _id), trashType);
        DataStorage(_storageContract).setUIntValue(sha3("trash_request_amount", _id), amount);
    }

    function getTrashRequest(address _storageContract, uint256 _id) constant returns (bytes32 hash, uint time, address sender, address receiver, string trashType, uint256 amount) {
        if (_storageContract == 0x0) throw;
        hash = DataStorage(_storageContract).getBytes32Value(sha3("trash_request_hash", _id));
        time = DataStorage(_storageContract).getUIntValue(sha3("trash_request_time", _id));
	sender = DataStorage(_storageContract).getAddressValue(sha3("trash_request_sender", _id));
        receiver = DataStorage(_storageContract).getAddressValue(sha3("trash_request_receiver", _id));
        trashType = DataStorage(_storageContract).getStringValue(sha3("trash_request_type", _id));
        amount = DataStorage(_storageContract).getUIntValue(sha3("trash_request_amount", _id));
    }

    function deleteTrashRequest(address _storageContract, uint256 _id) private {
	DataStorage(_storageContract).deleteBytes32Value(sha3("trash_request_hash", _id));
        DataStorage(_storageContract).deleteUIntValue(sha3("trash_request_time", _id));
	DataStorage(_storageContract).deleteAddressValue(sha3("trash_request_sender", _id));
        DataStorage(_storageContract).deleteAddressValue(sha3("trash_request_receiver", _id));
        DataStorage(_storageContract).deleteStringValue(sha3("trash_request_type", _id));
        DataStorage(_storageContract).deleteUIntValue(sha3("trash_request_amount", _id));
    }
}
