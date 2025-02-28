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
    event TripAdded(uint256 indexed tripIndex, string name, string location, uint256 startDate, uint256 endDate, uint256 price, address provider);
}

contract TripManager {
    using TravelLibrary for TravelLibrary.TripStorage;

    TravelLibrary.TripStorage private tripStorage;
    address public owner;

    mapping(address => uint256) public providerBalances;
    mapping(address => uint256) public customerBalances;
    mapping(address => bool) public activeBookings;
    mapping(address => mapping(uint256 => bool)) public bookedTrips;
    
    event BookingMade(address indexed customer, uint256 tripIndex, uint256 amount);
    event BookingCancelled(address indexed customer, uint256 tripIndex, uint256 amount);
    event TripCompleted(address indexed customer, address indexed provider, uint256 amount);
    event FundsWithdrawn(address indexed provider, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo l'owner puo' eseguire questa operazione");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addTrip(
        string memory name,
        string memory location,
        uint256 startDate,
        uint256 endDate,
        uint256 price
    ) public onlyOwner {
        require(startDate < endDate, "Le date non sono valide");

        tripStorage.trips.push(TravelLibrary.Trip(name, location, startDate, endDate, price, msg.sender));
        emit TravelLibrary.TripAdded(tripStorage.trips.length - 1, name, location, startDate, endDate, price, msg.sender);
    }

    function getTrips() public view returns (TravelLibrary.Trip[] memory) {
        return tripStorage.trips;
    }

    function bookTrip(uint256 tripIndex) public payable {
        require(tripIndex < tripStorage.trips.length, "Viaggio non esistente");
        require(!bookedTrips[msg.sender][tripIndex], "Viaggio gia' prenotato");
        require(msg.value == tripStorage.trips[tripIndex].price, "Importo errato");

        customerBalances[msg.sender] += msg.value;
        activeBookings[msg.sender] = true;
        bookedTrips[msg.sender][tripIndex] = true;
        emit BookingMade(msg.sender, tripIndex, msg.value);
    }

    function completeTrip(address provider, uint256 tripIndex) public {
        require(activeBookings[msg.sender], "Nessuna prenotazione attiva");
        require(bookedTrips[msg.sender][tripIndex], "Viaggio non prenotato");
        require(block.timestamp > tripStorage.trips[tripIndex].endDate, "Viaggio non ancora terminato");

        uint256 amount = customerBalances[msg.sender];
        customerBalances[msg.sender] = 0;
        providerBalances[provider] += amount;
        activeBookings[msg.sender] = false;
        bookedTrips[msg.sender][tripIndex] = false;

        emit TripCompleted(msg.sender, provider, amount);
    }

    function cancelBooking(uint256 tripIndex) public {
        require(activeBookings[msg.sender], "Nessuna prenotazione attiva");
        require(bookedTrips[msg.sender][tripIndex], "Viaggio non prenotato");
        require(block.timestamp < tripStorage.trips[tripIndex].startDate, "Viaggio gia' iniziato");

        uint256 refundAmount = customerBalances[msg.sender];
        customerBalances[msg.sender] = 0;
        activeBookings[msg.sender] = false;
        bookedTrips[msg.sender][tripIndex] = false;

        payable(msg.sender).transfer(refundAmount);
        emit BookingCancelled(msg.sender, tripIndex, refundAmount);
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
