pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract ChemicalsToken is TrashToken {

	function ChemicalsToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("ChemicalsToken", "ChT", 3, "kilo", false) {

    }

}
