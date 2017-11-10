pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract MixedToken is TrashToken {

	function MixedToken()
    TrashToken("MixedToken", "MxT", 3, "kilo", false) {

    }

}