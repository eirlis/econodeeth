pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract ElectronicsToken is TrashToken {

	function ElectronicsToken()
    TrashToken("ElectronicsToken", "ET", 3, "kilo", false) {

    }

}
