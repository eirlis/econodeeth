pragma solidity ^0.4.11;

import "./Token.sol";

contract TrashToken is Token {

	event TokensGenerated(address user, uint256 amount);

	event TokensBurned(address user, uint256 amount);
	

    string public mesurements;
    bool public danger;

    function TrashToken(string _name, string _symbol, uint8 _decimals, string _mesurements, bool _danger)
             Token(_name, _symbol, _decimals, 0) {
	mesurements = _mesurements;
	danger = _danger;
    }

    function emission(uint _value) {
        // Overflow check
        if (_value + totalSupply < totalSupply) throw;

        totalSupply     += _value;
        balances[msg.sender] += _value;
        TokensGenerated(msg.sender, _value);

    }

    function burn(uint _value) {
        if (balances[msg.sender] >= _value) {
            balances[msg.sender] -= _value;
            totalSupply      -= _value;
            TokensBurned(msg.sender, _value);
        }
    }
}
