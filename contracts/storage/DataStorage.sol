pragma solidity ^0.4.11;

import "../ownership/Owned.sol";
import "../ownership/AccessManager.sol";

contract DataStorage is Owned {

    uint8 public version = 1;

    Dispatcher public dispatcher;

    function DataStorage(address _dispatcher) {
        dispatcher = Dispatcher(_dispatcher);
    }

    function setDispatcher(address dispatcherAddress) onlyOwner {
        dispatcher = Dispatcher(dispatcherAddress);
    }

    modifier checkAccess {if (!AccessManager(dispatcher.getContract("AccessManager")).checkStorageAccess(msg.sender)) throw; _;}

	////////////
    //UInt
    ////////////
    mapping(bytes32 => uint) UIntStorage;

    function getUIntValue(bytes32 record) checkAccess constant returns (uint) {
        return UIntStorage[record];
    }

    function setUIntValue(bytes32 record, uint value) checkAccess {
        UIntStorage[record] = value;
    }

    function deleteUIntValue(bytes32 record) checkAccess {
      delete UIntStorage[record];
    }

    ////////////
    //Strings
    ////////////
    mapping(bytes32 => string) StringStorage;

    function getStringValue(bytes32 record) checkAccess constant returns (string) {
        return StringStorage[record];
    }

    function setStringValue(bytes32 record, string value) checkAccess {
        StringStorage[record] = value;
    }

    function deleteStringValue(bytes32 record) checkAccess {
      delete StringStorage[record];
    }

    ////////////
    //Address
    ////////////
    mapping(bytes32 => address) AddressStorage;

    function getAddressValue(bytes32 record) checkAccess constant returns (address) {
        return AddressStorage[record];
    }

    function setAddressValue(bytes32 record, address value) checkAccess {
        AddressStorage[record] = value;
    }

    function deleteAddressValue(bytes32 record) checkAccess {
      delete AddressStorage[record];
    }

    ////////////
    //Bytes
    ////////////
    mapping(bytes32 => bytes) BytesStorage;

    function getBytesValue(bytes32 record) checkAccess constant returns (bytes) {
        return BytesStorage[record];
    }

    function setBytesValue(bytes32 record, bytes value) checkAccess {
        BytesStorage[record] = value;
    }

    function deleteBytesValue(bytes32 record) checkAccess {
      delete BytesStorage[record];
    }

    ////////////
    //Bytes32
    ////////////
    mapping(bytes32 => bytes32) Bytes32Storage;

    function getBytes32Value(bytes32 record) checkAccess constant returns (bytes32) {
        return Bytes32Storage[record];
    }

    function setBytes32Value(bytes32 record, bytes32 value) checkAccess {
        Bytes32Storage[record] = value;
    }

    function deleteBytes32Value(bytes32 record) checkAccess {
      delete Bytes32Storage[record];
    }

    ////////////
    //Boolean
    ////////////
    mapping(bytes32 => bool) BooleanStorage;

    function getBooleanValue(bytes32 record) checkAccess constant returns (bool) {
        return BooleanStorage[record];
    }

    function setBooleanValue(bytes32 record, bool value) checkAccess {
        BooleanStorage[record] = value;
    }

    function deleteBooleanValue(bytes32 record) checkAccess {
      delete BooleanStorage[record];
    }

    ////////////
    //Int
    ////////////
    mapping(bytes32 => int) IntStorage;

    function getIntValue(bytes32 record) checkAccess constant returns (int) {
        return IntStorage[record];
    }

    function setIntValue(bytes32 record, int value) checkAccess {
        IntStorage[record] = value;
    }

    function deleteIntValue(bytes32 record) checkAccess {
      delete IntStorage[record];
    }
}