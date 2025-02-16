// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library TravelLibrary {
    struct Trip {
        string name;
        string location;
        uint256 startDate;
        uint256 endDate;
        uint256 price;
        address provider;
    }

    struct TripStorage {
        Trip[] trips;
    }

    event TripBooked(address indexed customer, uint256 tripIndex, uint256 amount);
}


contract TripManager {
    using TravelLibrary for TravelLibrary.TripStorage;

    TravelLibrary.TripStorage private tripStorage;

    mapping(address => uint256) public providerBalances;
    mapping(address => uint256) public customerBalances;
    mapping(address => bool) public activeBookings;

    event BookingMade(address indexed customer, uint256 amount);
    event BookingCancelled(address indexed customer, uint256 amount);
    event TripCompleted(address indexed customer, address indexed provider, uint256 amount);
    event FundsWithdrawn(address indexed provider, uint256 amount);

    function bookTrip(uint256 tripIndex) public payable {
        require(tripIndex < tripStorage.trips.length, "Viaggio non esistente");
        require(msg.value == tripStorage.trips[tripIndex].price, "Importo errato");

        customerBalances[msg.sender] += msg.value;
        activeBookings[msg.sender] = true;
        emit BookingMade(msg.sender, msg.value);
    }

    function completeTrip(address provider) public {
        require(activeBookings[msg.sender], "Nessuna prenotazione attiva");

        uint256 amount = customerBalances[msg.sender];
        customerBalances[msg.sender] = 0;
        providerBalances[provider] += amount;
        activeBookings[msg.sender] = false;

        emit TripCompleted(msg.sender, provider, amount);
    }

    function cancelBooking() public {
        require(activeBookings[msg.sender], "Nessuna prenotazione attiva");

        uint256 refundAmount = customerBalances[msg.sender];
        customerBalances[msg.sender] = 0;
        activeBookings[msg.sender] = false;

        payable(msg.sender).transfer(refundAmount);
        emit BookingCancelled(msg.sender, refundAmount);
    }

    function getCustomerBalance(address customer) public view returns (uint256) {
        return customerBalances[customer];
    }

    function getProviderBalance(address provider) public view returns (uint256) {
        return providerBalances[provider];
    }

    function withdrawFunds(uint256 amount) public {
        require(providerBalances[msg.sender] >= amount, "Fondi insufficienti");

        providerBalances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit FundsWithdrawn(msg.sender, amount);
    }
}
