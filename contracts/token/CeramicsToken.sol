pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract CeramicsToken is TrashToken {

	function CeramicsToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("CeramicsToken", "CT", 3, "kilo", false) {

    }

}
