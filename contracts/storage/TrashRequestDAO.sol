pragma solidity ^0.4.11;

import "./DataStorage.sol";

library TrashDAO {

    function version() constant returns (uint8) {
        return 1;
    }

    function getGenerateRequestsCount(address _storageContract) constant returns (uint256) {
        if (_storageContract == 0x0) throw;
        return DataStorage(_storageContract).getUIntValue(sha3("GenRequestCount"));
    }

    function addGenerateRequest(address _storageContract, uint time, address user, bytes32 activityType, uint256 amountActivity1, uint256
    amountActivity2, uint256 amountActivity3, uint256 amountCoins) returns (bool success, uint256 index, bytes32 hash) {
        if (_storageContract == 0x0) throw;
        if (time == 0) throw;
        if (user == 0x0) throw;
        if (amountActivity1 == 0 && amountActivity2 == 0 && amountActivity3 == 0) throw;
        if (amountCoins == 0) throw;
        index = DataStorage(_storageContract).getUIntValue(sha3("GenRequestIndex"));
        hash = sha3(index, time, user, amountCoins);
        setGenerateRequest(_storageContract, hash, index, time, user, activityType, amountActivity1, amountActivity2, amountActivity3,
        amountCoins);
        uint256 count = getGenerateRequestsCount(_storageContract);
        DataStorage(_storageContract).setUIntValue(sha3("GenRequestCount"), count + 1);
        DataStorage(_storageContract).setUIntValue(sha3("GenRequestIndex"), index + 1);
        success = true;
    }

    function removeGenerateRequest(address _storageContract, uint256 _id, bytes32 _hash) {
        if (_storageContract == 0x0) throw;
        var (hash,,,,,,,) = getGenerateRequest(_storageContract, _id);
        if (hash != _hash) throw; // protect from double remove
        uint256 lastIndex = DataStorage(_storageContract).getUIntValue(sha3("GenRequestIndex")) - 1;
        copyGenerateRequest(_storageContract, lastIndex, _id);
        uint256 count = getGenerateRequestsCount(_storageContract);
        DataStorage(_storageContract).setUIntValue(sha3("GenRequestCount"), count - 1);
        DataStorage(_storageContract).setUIntValue(sha3("GenRequestIndex"), lastIndex);
        deleteGenerateRequest(_storageContract, lastIndex);
    }

    function copyGenerateRequest(address _storageContract, uint256 fromIndex, uint256 toIndex) private {
        var (hash, time, user, activityType, amountActivity1, amountActivity2, amountActivity3, amountCoins) = getGenerateRequest
        (_storageContract, fromIndex);
        setGenerateRequest(_storageContract, hash, toIndex, time, user, activityType, amountActivity1, amountActivity2, amountActivity3,
        amountCoins);
    }

    function setGenerateRequest(address _storageContract, bytes32 hash, uint256 _id, uint time, address user, bytes32 activityType, uint256
    amountActivity1, uint256 amountActivity2, uint256 amountActivity3, uint256 amountCoins) private {
        DataStorage(_storageContract).setBytes32Value(sha3("gen_request_hash", _id), hash);
        DataStorage(_storageContract).setUIntValue(sha3("gen_request_time", _id), time);
        DataStorage(_storageContract).setAddressValue(sha3("gen_request_user", _id), user);
        DataStorage(_storageContract).setBytes32Value(sha3("gen_request_type", _id), activityType);
        DataStorage(_storageContract).setUIntValue(sha3("gen_request_activity1", _id), amountActivity1);
        DataStorage(_storageContract).setUIntValue(sha3("gen_request_activity2", _id), amountActivity2);
        DataStorage(_storageContract).setUIntValue(sha3("gen_request_activity3", _id), amountActivity3);
        DataStorage(_storageContract).setUIntValue(sha3("gen_request_coins", _id), amountCoins);
    }

    function getGenerateRequest(address _storageContract, uint256 _id) constant returns (bytes32 hash, uint time, address user, bytes32
    activityType, uint256 amountActivity1, uint256 amountActivity2, uint256 amountActivity3, uint256 amountCoins) {
        if (_storageContract == 0x0) throw;
        hash = DataStorage(_storageContract).getBytes32Value(sha3("gen_request_hash", _id));
        time = DataStorage(_storageContract).getUIntValue(sha3("gen_request_time", _id));
        user = DataStorage(_storageContract).getAddressValue(sha3("gen_request_user", _id));
        activityType = DataStorage(_storageContract).getBytes32Value(sha3("gen_request_type", _id));
        amountActivity1 = DataStorage(_storageContract).getUIntValue(sha3("gen_request_activity1", _id));
        amountActivity2 = DataStorage(_storageContract).getUIntValue(sha3("gen_request_activity2", _id));
        amountActivity3 = DataStorage(_storageContract).getUIntValue(sha3("gen_request_activity3", _id));
        amountCoins = DataStorage(_storageContract).getUIntValue(sha3("gen_request_coins", _id));
    }

    function deleteGenerateRequest(address _storageContract, uint256 _id) private {
        DataStorage(_storageContract).deleteUIntValue(sha3("gen_request_time", _id));
        DataStorage(_storageContract).deleteAddressValue(sha3("gen_request_user", _id));
        DataStorage(_storageContract).deleteBytes32Value(sha3("gen_request_type", _id));
        DataStorage(_storageContract).deleteUIntValue(sha3("gen_request_activity1", _id));
        DataStorage(_storageContract).deleteUIntValue(sha3("gen_request_activity2", _id));
        DataStorage(_storageContract).deleteUIntValue(sha3("gen_request_activity3", _id));
        DataStorage(_storageContract).deleteUIntValue(sha3("gen_request_coins", _id));
    }
}
