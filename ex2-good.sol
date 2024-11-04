//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherStore{
	mapping (address => uint256) public balances;
    bool public lock;

    modifier noReentrancy(){
        require(!lock, "No reentrancy");
        lock = true;
        _;
        lock = false;
    }

	function depositFunds() public payable {
		balances[msg.sender]+= msg.value;
	}

    
	function withdrawAllFunds() public noReentrancy {
        uint _bal = balances[msg.sender];
		require(_bal >= 0, "Insufficient funds");           //Check
         balances[msg.sender]= 0;                           //Effects	        
		(bool sent, ) = msg.sender.call{value: _bal }("");  //Interaction
		require(sent, "Failed: did not send");
	}
}