pragma solidity ^0.8.0;

contract TestFunction_token 
{
    
     mapping(address => uint) public balances;
     mapping(address => mapping(address => uint)) public allowance;   
     
     uint public totalSupply = 100 * 10 ** 10; // **10 étant à la puissance 10 pour les decimal et *10 pour avoir 420 unit sinon on a 0.420
     string public name = "Token"; // le nom du token
     string public symbol = "TKNA"; // le ticker 
     uint public decimals = 10; // le nombre de décimal, habituellement 18
     
     event Transfer(address indexed from, address indexed to, uint value);
     event Approval(address indexed owner, address indexed spender, uint value);

    constructor() {
        balances[msg.sender] = totalSupply; 
    }
    
    
    function balanceOf(address owner) public view returns(uint) //permet de consulter le solde d'une adresse   
    {
        return balances[owner]; 
    }
    
    
    function transfer(address to, uint value) public returns(bool) //permet de transferer le token d'une adresse à une autre
    {
    require(balanceOf(msg.sender) >= value, 'balance too low');
    balances[to] = balances[to] + value; 
    balances[msg.sender] -= value;  
    emit Transfer(msg.sender, to, value);
    return true;
    }
    
    function approve(address spender, uint value) public returns(bool) // utile pour les dex 
    {
    allowance[msg.sender][spender] = value;     
    emit Approval(msg.sender, spender, value);
    return true;
    }
    
    function transferFrom(address from, address to, uint value) public returns(bool) 
    {
    require(balanceOf(from) >= value, 'balance too low');    
    require(allowance[from][msg.sender] >= value, 'allowance too low');
    balances[to] += value; 
    balances[from] -= value;
    emit Transfer(from, to, value);
    return true;
    }

}