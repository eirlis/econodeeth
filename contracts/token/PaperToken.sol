pragma solidity ^0.4.11;

import "./TrashToken.sol";


contract PaperToken is TrashToken {

	function PaperToken()
    TrashToken("PaperToken", "PT", 3, "kilo", false) {

    }

}
