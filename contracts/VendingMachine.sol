// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract VendingMachine {
    address public owner;
    mapping (address => uint) public dounatBalances;

    constructor() {
        owner = msg.sender;
        // adress(this) - contract address
        dounatBalances[address(this)] = 100;
    }

    /// Only the owner can restock dounats!
    error OnlyOwner();

    /// You don't have enough ether! 
    error NotEnoughEther();

    /// The machine doesn't have enough dounats in stock, Sorry!
    error NotEnoughDounats();

    modifier onlyContractOwner() {
        if (msg.sender != owner)
            revert OnlyOwner();
        _;
    }

    modifier hasEnoughEther(uint amount) {
        if (msg.value <= amount * 50 wei) 
            revert NotEnoughEther();
            _;
        
    }

    modifier hasEnoughDounats(uint amount) {
        if (amount > dounatBalances[address(this)])
            revert NotEnoughDounats(); 
            _;
    }



    function getVendingMachineBalance() public view returns (uint) {
        return dounatBalances[address(this)];
    }

    function restock(uint amount) public onlyContractOwner {
        dounatBalances[address(this)] += amount;
    }

    // Can receive ether and change the state
    function purchase(uint amount) public hasEnoughEther(amount) hasEnoughDounats(amount) payable  {
        dounatBalances[address(this)] -= amount;
        dounatBalances[msg.sender] += amount;
    }

}