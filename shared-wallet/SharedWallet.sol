// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {
    uint totalAllowance;
    mapping(address => uint) userAllowances;
    event AllowanceChanged(address indexed user, uint oldAmount, uint newAmount);
    event MoneySent(address indexed user, uint amount);
    event MoneyReceived(address indexed user, uint amount);
    
    function changeAllowance(address user, uint newAmount) public onlyOwner {
        int balanceChange = int(newAmount) - int(userAllowances[user]);
        int newTotalAllowance = int(totalAllowance) + balanceChange;
        assert(newTotalAllowance >= 0);
        totalAllowance = uint(newTotalAllowance);
        
        require(totalAllowance <= address(this).balance, "Contract balance is too low");
        
        emit AllowanceChanged(user, userAllowances[user], newAmount);
        userAllowances[user] = newAmount;
    }
    
    function withdraw(uint amount) public {
        require(amount <= userAllowances[msg.sender], "Trying to withdraw more than allowance");
        
        emit AllowanceChanged(msg.sender, userAllowances[msg.sender], userAllowances[msg.sender] - amount);
        userAllowances[msg.sender] -= amount;

        emit MoneySent(msg.sender, amount);
        payable(msg.sender).transfer(amount);
    }
    
    function checkAllowance() public view returns(uint) {
        return userAllowances[msg.sender];
    }
    
    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}
