pragma solidity 0.8.4;

// import "./interfaces/IPool.sol";

contract Pool { // add is IPool if you add interface

    address public manager;
    uint256 public minimumStake;
    uint256 public maximumStake;
    uint256 public tokenValuationUSDC;
    uint256 public expiry;

    // Status of Reserved capital?
    // enum Status {
    //     Pending,
    //     Reserved
    // }

    constructor(
        address _manager, 
        uint256 _minimumStake, 
        uint256 _maximumStake, 
        uint256 _tokenValuationUSDC,
        uint256 _expiry
    ) {
        manager = _manager;
        minimumStake = _minimumStake;
        maximumStake = _maximumStake;
        tokenValuationUSDC = _tokenValuationUSDC;
        expiry = _expiry;
    }

    // *** Manager related functionality: ***
    function deposit(uint256 _amount, uint256 _expiry) public {
        require(msg.sender == manager);
    } 

    function redeem(uint256 _amount) public {
        require(block.timestamp > expiry, "Pool: Not yet expired");
        require(msg.sender == manager, "Pool: Not manager");
    }  

    function transferFromReserve(uint256 _amount, uint256 _recipient) {
        require(msg.sender == manager);
        emit TransferredFromReserve(address(this), projectID, amount, _recipient)
    }

    function transferFromPool(uint256 _amount, uint256 _recipient) {
        require(msg.sender == manager);

    }

    function reserve(uint256 _amount) public {
        require(msg.sender == manager);
        // Maybe introduce max amount that can be reserved as a security measure for investors
        emit Reserved(address(this), projectID, amount)
    }

    // function announceReservation?

    // *** Investor related functionality: ***
    function stake(uint256 _amount) public returns (bool) {
        // Only USDC/DAI?
    }

    function withdrawStake(uint256 _amount) public {
        // ...
    }

}