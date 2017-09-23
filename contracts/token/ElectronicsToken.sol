pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract ElectronicsToken is TrashToken {

	function ElectronicsToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("ElectronicsToken", "ET", 3, "kilo", false) {

    }

}
