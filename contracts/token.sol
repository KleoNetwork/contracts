// // SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


contract Token is ERC20, AccessControl {
    bytes32 public constant ADMIN = keccak256("ADMIN");
    bytes32 public constant MINTER = keccak256("MINTER");
    bytes32 public constant BURNER = keccak256("BURNER");
    uint minimumFaucetAmount;


    constructor(string memory _name, string memory _symbol, uint _minimumFaucetAmount) ERC20(_name, _symbol){
        _mint(msg.sender, 10000000 * (10 ** uint(decimals())));
        _setupRole(ADMIN, msg.sender);
        _setRoleAdmin(MINTER, ADMIN);
        _setRoleAdmin(BURNER, ADMIN);      
        minimumFaucetAmount = _minimumFaucetAmount;
    }
    
    function mint(address _to, uint _value) onlyRole(MINTER) public {
        _mint(_to, _value);
    }
    function faucet(address _to, uint _value) public {
        require(minimumFaucetAmount >= _value);
        _mint(_to, _value);
    }
    function approveContract(address contractAddress) public {
        _approve(address(this), contractAddress, 100000000000); 
    }
    function burn(address _from, uint _value) onlyRole(BURNER) public {
        _burn(_from, _value);
    } 
    
}
