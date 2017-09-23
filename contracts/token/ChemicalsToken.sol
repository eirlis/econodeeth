pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract ChemicalsToken is TrashToken {

	function ChemicalsToken()
    TrashToken("ChemicalsToken", "ChT", 3, "kilo", false) {

    }

}
