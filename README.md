# TripManager Smart Contract

## Description
TripManager is a smart contract written in Solidity to manage the booking of travel without intermediaries. The contract allows customers to book trips, securely manage payments, and ensure the transfer of funds to travel service providers upon completion of the trip.

## Features
- **Booking a trip**: Customers can book a trip by paying the requested amount.
- **Completing the trip**: Suppliers receive payment upon completion of the trip.
- **Cancellation of the booking**: Customers can cancel the booking and get a refund.
- **Managing balances**: You can view the balance of customers and suppliers.
- **Withdrawing funds**: Suppliers can withdraw their earned funds.

## Code Structure
- **`TravelLibrary`**: Library for managing the travel structure.
- **`TripManager`**: Main contract that uses `TravelLibrary` to manage reservations.

## Installation
1. Make sure you have a Solidity development environment (Remix, Hardhat, Foundry, or Truffle).
2. Compile and deploy the contract on an Ethereum-compatible blockchain.

## License
This project is licensed under the MIT license.
