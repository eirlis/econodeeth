pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract TextilesToken is TrashToken {

	function TextilesToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("TextilesToken", "TT", 3, "kilo", false) {

    }

}
