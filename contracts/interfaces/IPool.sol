
pragma solidity 0.8.4;

/**
 * @title Interface for the Pool contract.
 */
interface IPool {

    
    // function addToWhitelist(address[] memory _address) external;

    // function removeFromWhitelist(address[] memory _address) external;

    // function isWhitelisted(address _address) external view returns(bool);

    // function addDatafeeds(address _address, string[] memory _underlyings) external;

    // function activateDatafeeds(address _address, uint256[] memory _index, string[] memory _matchUnderlying) external;

    // function deactivateDatafeeds(address _address, uint256[] memory _index, string[] memory _matchUnderlying) external;

    // function getDatafeeds(address _address) external view returns (Datafeed[] memory);

    // function getAllProviders() external view returns (address[] memory);

    // function getOwner() external view returns (address);

    event Reserved(address indexed poolAddress, uint256 indexed projectID, uint256 amount, address indexed recipient);
    event TransferredFromReserve(address indexed poolAddress, uint256 indexed projectID, uint256 amount, address indexed recipient)

    // event RemovedFromWhitelist(address indexed providerAddress);
    // event UpdatedDatafeedActiveFlagByOwner(address indexed providerAddress, string underlying);
    // event ActivatedDatafeedByProvider(address indexed providerAddress, string underlying);
    // event DeactivatedDatafeedByProvider(address indexed providerAddress, string underlying);
    // event RemovedDatafeed(address indexed providerAddress, string underlying);
    // event AddedDatafeed(address indexed providerAddress, string underlying);

}