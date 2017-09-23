pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract GlassToken is TrashToken {

	function GlassToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("GlassToken", "GT", 3, "kilo", false) {

    }

}
