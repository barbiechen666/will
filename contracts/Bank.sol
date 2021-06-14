// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract Bank{
    address[] owners;
    address mainowner;
    mapping(address => bool) isOwner;
    mapping(address => uint) balances;
    bool activated;

    modifier checkSameOwner (address addr){
        require(mainowner == addr, "not contract owner");
        _; //執行
    }

    //存錢進合約
    function deposit() public payable{
        balances[msg.sender]+=msg.value;
    }

    constructor () public{
        owners = [msg.sender];
        mainowner = msg.sender;
        isOwner[msg.sender] = true;
        activated = false;
    }
    
    //領錢出來
    function withdraw(uint amount) public payable checkSameOwner(msg.sender){
        require((amount*1000000000000000000) <= address(this).balance, "not enough funds");
        (bool sent, ) = msg.sender.call.value(amount*1000000000000000000)("");
        require(sent, "Failed to send Ether");
    }

    //查看合約的錢
    function getBankBalance() public view returns(uint){
        return address(this).balance;
    }
}