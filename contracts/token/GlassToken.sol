pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract GlassToken is TrashToken {

	function GlassToken()
    TrashToken("GlassToken", "GT", 3, "kilo", false) {

    }

}
