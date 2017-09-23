pragma solidity ^0.4.11;

import "./TrashToken.sol";

contract PlasticsToken is TrashToken {

	function PlasticsToken()
    TrashToken("PlasticsToken", "PT", 3, "kilo", false) {

    }

}