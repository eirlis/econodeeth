pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract MetalToken is TrashToken {

	function MetalToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("MetalToken", "MT", 3, "kilo", false) {

    }

}
