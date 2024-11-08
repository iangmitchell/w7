//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

interface SimpleToken{
	function addAccount(address _account) external;
	function deposit(address _from, uint _amount) external ;
	function freezeAccount(address _account)  external;
	function isFrozen(address _account) external returns(bool);
	function withdraw(address _to, uint amount) external ;
	function thawAccount(address _account) external;
}

contract MDXToken is SimpleToken{
	address public banker;
	//uint public balance;
    mapping (address=>uint) public savings;
	mapping (address => uint) public balanceMap;
	mapping (address => bool) public freezeMap;
    mapping (address => uint) public freezeInterval;
	uint public tokenSupply = 1000000000; //mdx-wei
	uint constant INIT = 10000;
    uint interval = 60;
	event Transfer(address, uint);

//ACCESS MODIFIERS
	modifier bankerOnly(){
		require(msg.sender == banker, "Insufficient access: banker only");
		_;
	} 

	modifier ownerOnly(address _account){
		require(msg.sender == _account, "Insufficient access: owner only");
		_;
	}


	constructor () {
        banker = msg.sender;
        balanceMap[banker] = INIT;
		tokenSupply-=INIT;
    }
	
	/*
	* Creates an account with an initial supply of tokens
	*/
	function addAccount(address _account) public bankerOnly override {
		require(tokenSupply>=INIT, "Tokens supply exceeded");
        balanceMap[_account] = INIT;
		tokenSupply-=INIT;
        freezeMap[_account] = false;
        freezeInterval[_account] = block.timestamp;
    }

	/*
	* Deposit funds to banker, 
	* Freeze _from account
	* Can only collect after freeze interval expired
	*/
    function deposit(address _from, uint _amount) public ownerOnly(_from) override {
        require(balanceMap[_from]>=_amount, "Not enough in account");
		require(!isFrozen(_from), "Account Frozen");
        	balanceMap[_from]-=_amount;
			savings[_from]+=_amount;
        	freezeAccount(_from);
    }
	
	/*
	* Allows withdrawal
	* checks for frozen account
	* must call thawAccount before
	* if not frozen then allows transfer
	* emits event
	*/
	function withdraw(address _to, uint _amount) public ownerOnly(_to) override {
		thawAccount(_to);
		require(!freezeMap[_to], "Account Frozen");
		require(savings[_to]>=_amount, "insufficient funds");
		    //thawAccount(_to);
			//balance-= balance;
			balanceMap[_to]+=_amount;
			savings[_to]-=_amount;
			emit Transfer(_to, _amount);
	}

	/*
	* Option to freeze account
	* owner access only
	*/
	function freezeAccount(address _account) public ownerOnly(_account) override {
		freezeMap[_account] = true;
        freezeInterval[_account] = block.timestamp + interval;
	}

	/* 
	* unfreeze account
	* requires the time interval to be expired
	* then withdraw/deposit
	*/
    function thawAccount(address _account) public ownerOnly(_account) override {
		require(freezeInterval[_account] < block.timestamp, "Account Frozen");
        freezeMap[_account]=false;    
		freezeInterval[_account]=block.timestamp - 1;
    }

	/* 
	* check if account is frozen
	*/
	function isFrozen(address _account) public override view returns (bool){
		return ( freezeMap[_account] );
	}


}

//1 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//2 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//3 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db