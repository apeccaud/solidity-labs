# Shared Wallet Project

This is a simple smart contract implementing a shared wallet.

- Everybody can send ether to the contract
- The contract owner can assign allowances to users
    - The sum of all allowances must be lower or equal to the contract balance
- A user can withdraw ether up to his allowance
