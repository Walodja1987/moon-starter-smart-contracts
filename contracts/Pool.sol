pragma solidity 0.8.4;

// import "./interfaces/IPool.sol";

contract Pool { // add is IPool if you add interface

    address public manager;
    uint256 public minimumStake;
    uint256 public maximumStake;
    uint256 public tokenValuationUSDC;
    uint256 public expiry;

    uint256 public maxFutureTokenSupply;
    uint256 public poolTokenSupply;


    // Investor => allocated amount
    mapping(address => uint256) public allocations; 
    mapping(address => uint256) public claimedAmount;
    mapping(address => uint256) public blockedAmounts;
    uint256 public remainingClaims;  // at pool creation remainingClaims = poolTokenSupply; 
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
        uint256 _expiry,
        uint256 _maxFutureTokenSupply,
        uint256 _poolTokenSupply
    ) {
        manager = _manager;
        minimumStake = _minimumStake; //updateable?; agree on default values
        maximumStake = _maximumStake; //updateable?; agree on default values
        tokenValuationUSDC = _tokenValuationUSDC; //not updateable for now; updateable in v2
        expiry = _expiry;
        maxFutureTokenSupply = _maxFutureTokenSupply;
        poolTokenSupply = _poolTokenSupply; // 
    }

    modifier OnlyManager() {
        require(msg.sender == manager);
        _;
    }

    modifier IsNotExpired() {
        require(block.timestamp < expiry, "Pool: Not yet expired");
        _;
    }

    // *** Manager related functionality: ***
    function depositTokensAtLaunch(uint256 _amount, uint256 _expiry) public {
        require(msg.sender == manager);
    }

    function redeemUnclaimedClaims(uint256 _amount) public {
        require(block.timestamp > expiry, "Pool: Not yet expired");
        require(msg.sender == manager, "Pool: Not manager");
    }  

    function transferFromReserve(uint256 _amount, address _recipient) { // send from blocked funds after work is done
        require(msg.sender == manager);
        emit TransferredFromReserve(address(this), projectID, amount, _recipient)
    }



    function transferFromPool(uint256 _amount, address _recipient) {
        require(msg.sender == manager);

    }

    // v1: investor stellt sein Kapital zur Verfügung und Startup kann damit machen, was es will
    // Fix terms / contract with contributor
    // Store ratio between agreed payment in tokens and USDC
    // Store Hash of agreement/contract with contributor / store on IPFS
    function setContributionTerms() public {
        // OnlyManager()
        // Check that available claims are not exceed

    }

    // Block claims to avoid scenario where you allocate more than the pool size 

    function updateClaimForContributor(uint256 _amount) {} 

    // Update claim for contributor
    // Split between token payment and USDC



    // function getListOfInvestors() public (memory address[]) {
    //     // OnlyManager()
    //     // return array of addresses
    // }


    function block(uint256 _amount) public {
        require(msg.sender == manager);
        // Maybe introduce max amount that can be reserved as a security measure for investors
        // Loop through list of investors and block funds that cannot be unstaked (initial version)
        // OPEN: Ask for help in DeveloperDAO how to potentially avoid the for loop
        // Update blockedAmounts
        emit Reserved(address(this), projectID, amount)
    }

    function unblock(uint256 amount) public {
        // OnlyManager
        // update blockedAmounts
    }

    function flagClaimable() public {} // for claims prior to expiration date

    // function announceReservation?

    // *** Investor related functionality: ***
    function stake(uint256 _amount) public returns (bool) {
        // Only USDC/DAI?
    }

    function unstake(uint256 _amount) public {
        // Withdrawable amount is reduced by blocked amount
    }



    // claim allocation of ERC20 token after token was released; store tx hash of claim on-chain / within contract; proof of honesty
    function setTokenAddressAtLaunch() public {
        // OnlyManager
    }

    // struct Claims {
    //     address investor;
    //     uint256 amount;
    //     uint256 timestamp; //?
    // }

    

    // Only after expiry
    function claimTokens() {
        // Check allcoated amount for investor
    }

}



