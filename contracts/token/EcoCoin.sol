pragma solidity ^0.4.11;

import './Token.sol';

contract EcoCoin is Token {

    event TokensGenerated(address user, uint256 amount);

    event TokensBurnt(address user, uint256 amount);
    

    function EcoCoin(uint _start_count)
             Token("EcoCoin", "ECT", 18, _start_count) {}

    function emission(uint _value) onlyOwner {
        // Overflow check
        if (_value + totalSupply < totalSupply) throw;

        totalSupply     += _value;
        balances[owner] += _value;
        TokensGenerated(owner, _value);
    }
  
    function burn(uint _value) {
        if (balances[msg.sender] >= _value) {
            balances[msg.sender] -= _value;
            totalSupply      -= _value;
            TokensBurnt(msg.sender, _value);
        }
    }
}
