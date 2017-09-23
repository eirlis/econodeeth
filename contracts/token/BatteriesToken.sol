pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract BatteriesToken is TrashToken {

	function BatteriesToken()
    TrashToken("BatteriesToken", "BT", 3, "kilo", true) {

    }

}
