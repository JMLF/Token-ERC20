pragma solidity ^0.8.0;

contract defla_token 
{
    
     mapping(address => uint) public balances;     
     mapping(address => mapping(address => uint)) public allowance;   
     
     uint public totalSupply = 100 * 10 ** 18; // **10 étant à la puissance 10 pour les decimal et *10 pour avoir 420 unit sinon on a 0.420
     string public name = "defla"; // le nom du token
     string public symbol = "DFLA"; // le ticker 
     uint public decimals = 18; // le nombre de décimal, habituellement 18
     
     uint public transactions; 
     uint public deflationfee; 
     
     event Transfer(address indexed from, address indexed to, uint value);
     event Approval(address indexed owner, address indexed spender, uint value);

    constructor() {
        balances[msg.sender] = totalSupply; 
    }
    
    function balanceOf(address owner) public view returns(uint) //permet de consulter le solde d'une adresse   
    {
        return balances[owner]; 
    }
    
     function deflation(uint NbTransac) public returns(uint) //prend en compte le nb de transac pour aajuster la deflation   
    {
        if(NbTransac <= 2) {
            return 1;
        }
          if(NbTransac <= 5) {
            return 5;
        }
          if(NbTransac <= 7) {
            return 10;
        }
          if(NbTransac <= 9) {
            return 50;
        }
    }
    
    
    function transfer(address to, uint value) public returns(bool) //permet de transferer le token d'une adresse a une autre (c'est la qu'on ajoute une fonction pour enlever 5% sur chaque transac)
    {
        
        transactions ++;
        deflationfee=deflation(transactions);
        
    require(balanceOf(msg.sender) >= value, 'balance too low');
    balances[to] = balances[to] + (value - (value*deflationfee /100)); 
    balances[msg.sender] -= value;  
    emit Transfer(msg.sender, to, value);
    return true;
    }
    
    function approve(address spender, uint value) public returns(bool)  
    {
    allowance[msg.sender][spender] = value;     
    emit Approval(msg.sender, spender, value);
    return true;
    }
    
    function transferFrom(address from, address to, uint value) public returns(bool)  
    {    
        transactions ++;
        deflationfee=deflation(transactions);
        
    require(balanceOf(from) >= value, 'balance too low');    
    require(allowance[from][msg.sender] >= value, 'allowance too low');
    balances[to] += (value - (value*deflationfee /100)); 
    balances[from] -= value;
    emit Transfer(from, to, value);
    return true;
    }

}