pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract CeramicsToken is TrashToken {

	function CeramicsToken()
    TrashToken("CeramicsToken", "CT", 3, "kilo", false) {

    }

}
