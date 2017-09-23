pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract MetalToken is TrashToken {

	function MetalToken()
    TrashToken("MetalToken", "MT", 3, "kilo", false) {

    }

}
