pragma solidity 0.8.4;

import "./interfaces/IWhitelist.sol";

contract Whitelist is IWhitelist {
    
    // Q: ?
    mapping(address => bool) whitelist;
    mapping(address => Datafeed[]) public datafeeds;
    address[] public providers;  // Can someone modify the array from outside via a pop()? add separate getter and setter functions

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
    require(msg.sender == owner, "Only owner.");
    _;
    }
    
    /// @notice Function to add addresses to the whitelist
    /// @dev Providers array may include duplicates, e.g., if an address was whitelisted, then removed and then whitelisted again
    /// @param _address Array of addresses to be added to the whitelist
    function addToWhitelist(address[] memory _address) public override onlyOwner {
        for (uint256 i=0; i < _address.length; i++) {
            require(_address[i] != address(0), "Null address"); // Needed?
            whitelist[_address[i]] = true;
            providers.push(_address[i]); 
            emit AddedToWhitelist(_address[i]);
        }
    }

    /// @notice Function to remove addresses from the whitelist
    /// @param _address Array of addresses to be removed from the whitelist
    function removeFromWhitelist(address[] memory _address) public override onlyOwner {
        for (uint256 i=0; i < _address.length; i++) {
            require(_address[i] != address(0), "Null address"); // Needed?
            whitelist[_address[i]] = false;
            emit RemovedFromWhitelist(_address[i]);
        }
    }
    
    /// @notice Function to check whether an address is a whitelisted datafeed provider
    /// @param _address Address
    function isWhitelisted(address _address) public override view returns (bool) {
        return whitelist[_address];
    }
    
    /// @notice Function to add a list of datafeeds for a given provider address
    /// @dev Function does not prevent duplicate entries; user needs to make sure that no duplicate entries are added (use the getDatafeeds function to see the existing datafeeds for a given provider address)
    /// @param _address Datafeed provider address
    /// @param _underlyings Array of underlyings to be added for the given datafeed provider (isActive flag is set to true automatically)
    function addDatafeeds(address _address, string[] memory _underlyings) public override onlyOwner {
        for (uint256 i=0; i < _underlyings.length; i++) {
            // if underlying already exists, then do not add (to avoid the scenario, where two entries exist, one set to false and one to true)
            datafeeds[_address].push(Datafeed(_underlyings[i], true));
            emit AddedDatafeed(_address, _underlyings[i]);
        }
    }

    /// @notice Function to activate datafeeds in the Datafeed struct for a given provider address
    /// @dev This function can only be called by the owner
    /// @param _address Datafeed provider address
    /// @param _index Indices to be updated in the datafeed array
    /// @param _matchUnderlying The expected underlying string at the given index; this is just an additional check to ensure that the correct entries in the datafeed array are updated
    function activateDatafeeds(address _address, uint256[] memory _index, string[] memory _matchUnderlying) public override onlyOwner {
        require(_index.length == _matchUnderlying.length, "Arrays are of different lengths.");
        for (uint256 i=0; i < _index.length; i++) {
            require(keccak256(bytes(datafeeds[_address][_index[i]].underlying)) == keccak256(bytes(_matchUnderlying[i])), "Mismatch between underlying name at provided index and expected name.");
            require(datafeeds[_address][_index[i]].isActive == false, "Datafeed is already active.");
            require(_index[i] >= 0, "Index cannot be negative.");
            datafeeds[_address][_index[i]].isActive = true;
            emit ActivatedDatafeedByProvider(_address, _matchUnderlying[i]);
        }
    }

    /// @notice Function to deactivate datafeeds in the Datafeed struct for a given provider address
    /// @dev This function can only be called by the owner and the datafeed provider
    /// @param _address Datafeed provider address
    /// @param _index Indices to be updated in the datafeed array
    /// @param _matchUnderlying The expected underlying string at the given index; this is just an additional check to ensure that the correct entries in the datafeed array are updated
    function deactivateDatafeeds(address _address, uint256[] memory _index, string[] memory _matchUnderlying) public override {
        require(_index.length == _matchUnderlying.length, "Arrays are of different lengths.");
        require(msg.sender == _address || msg.sender == owner, "Only owner or datafeed provider.");
        for (uint256 i=0; i < _index.length; i++) {
            require(keccak256(bytes(datafeeds[_address][_index[i]].underlying)) == keccak256(bytes(_matchUnderlying[i])), "Mismatch between underlying name at provided index and expected name.");
            require(datafeeds[_address][_index[i]].isActive == true, "Datafeed is already deactivated.");
            require(_index[i] >= 0, "Index cannot be negative.");
            datafeeds[_address][_index[i]].isActive = false;
            emit DeactivatedDatafeedByProvider(_address, _matchUnderlying[i]);
        }
    }

    /// @notice Function to return all the datafeeds for a given datafeed provider address; returns an empty array if no datafeeds have been assigned yet
    /// @param _address Datafeed provider address
    function getDatafeeds(address _address) public override view returns (Datafeed[] memory) {
        return datafeeds[_address]; 
    }

    /// @notice Function returns all addresses that have been added to the whitelist at some point. 
    ///         IMPORTANT: Addresses are NOT necessarily whitelisted anymore. Use the isWhitelisted function to identify the whitelisted ones
    function getAllProviders() public override view returns (address[] memory) {
        return providers;
    }

    /// @notice Function returns the owner address of the contract
    function getOwner() public override view returns (address) {
        return owner;
    }

}