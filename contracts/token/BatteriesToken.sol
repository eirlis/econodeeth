pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract BatteriessToken is TrashToken {

	function BatteriesToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("BatteriesToken", "BT", 3, "kilo", true) {

    }

}
