//SPDX-License-Identifier:MIT   
pragma solidity ^0.7.0;
contract badEtherStore{
        mapping (address=>uint) public balances;
        mapping (address=>uint) public lockTimes;

        function getBalance () public view returns (uint){
                return address(this).balance;
        }

        function getBalance (address _addr) public view returns (uint){
                return balances[_addr];
        }
        
        function getLockTime (address _addr) public view returns (uint){
                return lockTimes[_addr];
        }

        function deposit () public payable{
                
                balances[msg.sender] += msg.value;
                lockTimes[msg.sender] = block.timestamp + 600; // 10 mins
                //2^256 -1 = 115792089237316195423570985008687907853269984665640564039457584007913129639935
                //2^256 -1 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        }

        function increaseLockTime (uint _seconds) public {
                lockTimes[msg.sender] += _seconds;
        }

        function withdraw() public payable {
                address payable user = payable(msg.sender);
                require(balances[msg.sender] > 0, "Insufficient funds");
                require(lockTimes[msg.sender] <= block.timestamp, "Account Frozen");
                uint balance = balances[msg.sender];
                balances[msg.sender]=0;
                user.transfer(balance);
        } 
}   

