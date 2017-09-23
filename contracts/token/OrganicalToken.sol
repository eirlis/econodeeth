pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract OrganicalToken is TrashToken {

	function OrganicalToken()
    TrashToken("OrganicalToken", "OT", 3, "kilo", false) {

    }

}
