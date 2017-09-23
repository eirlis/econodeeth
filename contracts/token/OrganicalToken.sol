pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract Organical is TrashToken {

	function OrganicalToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("OrganicalToken", "OT", 3, "kilo", false) {

    }

}
