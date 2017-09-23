pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract PlasticsToken is TrashToken {

	function PlasticsToken()
    TrashToken("PlasticsToken", "PlT", 3, "kilo", false) {

    }

}