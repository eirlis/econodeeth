pragma solidity ^0.4.11;

import "../ownership/Owned.sol";
import "../ownership/Destroyable.sol";
import "../Dispatcher.sol";
import "../token/EcoCoin.sol";

contract Exchange is Owned, Destroyable {

    event Success(uint time, address user);
    event NotEnoughtCoins(uint time, address user);
    event Error(uint time, address user);

    Dispatcher public dispatcher;

    function Exchange(address dispatcherAddress) {
	setDispatcher(dispatcherAddress);
    }

    function setDispatcher(address dispatcherAddress) onlyOwner {
        if (dispatcherAddress == 0x0) throw;
        dispatcher = Dispatcher(dispatcherAddress);
    }

    function checkCoinsOnMarket(uint256 amount) returns (bool) {
	return EcoCoin(dispatcher.getContract("EcoCoin")).balanceOf(address(this)) >= amount;
    }

    function exchangeCoinToFiat(uint256 amount) {
        if (amount == 0) throw;
        if (EcoCoin(dispatcher.getContract("EcoCoin")).transferFrom(msg.sender, address(this), amount)) {
            	Success(now, msg.sender);
        } else {
            	Error(now, msg.sender);
        }
    }

    function exchangeFiatToCoin(uint256 amount) {
	if (amount == 0) throw;
        if (!checkCoinsOnMarket(amount)) {
                NotEnoughtCoins(now, msg.sender);
                return;
        }
	if (EcoCoin(dispatcher.getContract("EcoCoin")).transfer(msg.sender, amount)) {
                Success(now, msg.sender);
        } else {
                Error(now, msg.sender);
        }
    }

    function() payable {
	if (msg.sender != owner) throw;
    }
}
