pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract MixedToken is TrashToken {

	function MixedToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("MixedToken", "MT", 3, "kilo", false) {

    }

}
