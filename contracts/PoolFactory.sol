pragma solidity 0.8.4;

// import "./interfaces/IMoonstarter.sol";

import "./Pool.sol";

contract PoolFactory {

    address[] public deployedPools;

    function createPool(
        address _manager, 
        uint256 _minimumStake, 
        uint256 _maximumStake, 
        uint256 _tokenValuationUSDC,
        uint256 _expiry
        ) public {
            address newPool = new Pool(_manager, _minimumStake, _maximumStake, _tokenValuationUSDC, _expiry);
            deployedPools.push(newPool);
    }

    function getDeployedPools() public view returns (address[]) {
        return deployedPools;
    }
    
}