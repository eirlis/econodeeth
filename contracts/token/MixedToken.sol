pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract MixedToken is TrashToken {

	function MixedToken()
    TrashToken("MixedToken", "MT", 3, "kilo", false) {

    }

}
