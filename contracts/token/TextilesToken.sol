pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract TextilesToken is TrashToken {

	function TextilesToken()
    TrashToken("TextilesToken", "TT", 3, "kilo", false) {

    }

}
