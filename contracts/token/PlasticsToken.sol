pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract PlasticsToken is TrashToken {

	function PlasticsToken(string _name, string _symbol, uint8 _decimals, string _measurements, bool _danger)
    TrashToken("PlasticsToken", "PT", 3, "kilo", false) {

    }

}