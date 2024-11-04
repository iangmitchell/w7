//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherStore{
	mapping (address => uint256) public balances;

	function depositFunds() public payable {
		balances[msg.sender]+= msg.value;
	}

	function withdrawAllFunds() public {
        uint _bal = balances[msg.sender];
		require(_bal >= 0, "Insufficient funds");           //Check
		(bool sent, ) = msg.sender.call{value: _bal }("");  //Interaction
		require(sent, "Failed: did not send");
        balances[msg.sender]= 0;                            //Effects		
	}
}