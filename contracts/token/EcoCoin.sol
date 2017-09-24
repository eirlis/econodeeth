pragma solidity ^0.4.11;

import './Token.sol';
import "../Dispatcher.sol";

contract EcoCoin is Token {

    event TokensGenerated(address user, uint256 amount);
    event TokensBurnt(address user, uint256 amount);

    Dispatcher public dispatcher;    

    function EcoCoin(uint _start_count, address dispatcherAddress)
             Token("EcoCoin", "ECT", 18, _start_count) {
	setDispatcher(dispatcherAddress);
    }

    function setDispatcher(address dispatcherAddress) onlyOwner {
        if (dispatcherAddress == 0x0) throw;
        dispatcher = Dispatcher(dispatcherAddress);
    }

    function emission(uint _value) onlyOwner {
        // Overflow check
        if (_value + totalSupply < totalSupply) throw;

	address beneficiar = dispatcher.getContract("Exchange");
        totalSupply += _value;
        balances[beneficiar] += _value;
        TokensGenerated(beneficiar, _value);
    }
  
    function burn(uint _value) {
        if (balances[msg.sender] >= _value) {
            balances[msg.sender] -= _value;
            totalSupply      -= _value;
            TokensBurnt(msg.sender, _value);
        }
    }
}
