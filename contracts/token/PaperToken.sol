pragma solidity ^0.4.11;

import "./TrashToken.sol";


contract PaperToken is TrashToken {

	function PaperToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("PaperToken", "PT", 3, "kilo", false) {

    }

}
