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
	uint public balance;
	mapping (address => uint) public balanceMap;
	mapping (address => bool) public freezeMap;
	mapping (address => uint) public freezeInterval;
	uint constant TOKEN_SUPPLY = 1000000000; //mdx-wei
	uint constant INIT = 10000;
	uint interval = 60;
	event Transfer(address, uint);

//ACCESS MODIFIERS
	modifier bankerOnly(){
		require(msg.sender == banker, "Insufficient access: banker only");
		_;
	} 

	modifier ownerOnly(_______ _account){
		require(msg.______ == _account, "Insufficient access: owner only");
		_;
	}


	constructor () {
		banker = msg.sender;
		balance = TOKEN_SUPPLY;
	}
	
	/*
	* Creates an account with an initial supply of tokens
	*/
	function addAccount(address _account) public bankerOnly override {
		require(____________, "Tokens supply exceeded");
        	balanceMap[________] = INIT;
		_______-= INIT;
        	freezeMap[_account] = false;
	        freezeInterval[_account] = block.timestamp;
	}

	/*
	* Deposit funds to banker, 
	* Freeze _from account
	* Can only collect after freeze interval expired
	*/
	function deposit(address _from, uint _amount) public ownerOnly(_from) override {
		require(__________[_from]>=_______, "Not enough in account");
		require(!________(_from), "Account Frozen");
        	balanceMap[_from]-=_amount;
        	balance+=_amount;
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
		thawAccount(___);
		require(!_________[_to], "Account Frozen");
			_______-= _amount;
			__________[_to]+=_amount;
			emit Transfer(_to, _amount);
	}

	/*
	* Option to freeze account
	* owner access only
	*/
	function freezeAccount(address _account) public ownerOnly(_account) override {
		freezeMap[_account] = ____;
        	freezeInterval[_account] = _____._________ + interval;
	}

	/* 
	* unfreeze account
	* requires the time interval to be expired
	* then withdraw/deposit
	*/
	function thawAccount(address _account) public ownerOnly(________) override {
		require(freezeInterval[_account] _ _____._________, "Account Frozen");
       		freezeMap[_account]=_____;    
		freezeInterval[_account]=_____._________ - 1;
	}

	/* 
	* check if account is frozen
	*/
	function isFrozen(address _account) public override view returns (____){
		return ( _________[_account] );
	}
}

