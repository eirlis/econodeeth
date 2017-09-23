pragma solidity ^0.4.11;

import "./Token.sol";

contract TrashToken is Token {

    string public mesurements;
    bool public danger;

    function TrashToken(string _name, string _symbol, uint8 _decimals, string _mesurements, bool _danger)
             Token(_name, _symbol, _decimals, 0) {
	mesurements = _mesurements;
	danger = _danger;
    }
}
