// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";
import "https://github.com/UMAprotocol/protocol/blob/7a93650a7494eaee83756382a18ecf11314499cf/packages/core/contracts/optimistic-oracle-v3/interfaces/OptimisticOracleV3Interface.sol";

contract BrowniePoints {
   
    struct DataAssertion {
        bytes32 dataId; // The dataId that was asserted.
        bytes32 data; // This could be an arbitrary data type.
        address asserter; // The address that made the assertion.
        bool resolved; // Whether the assertion has been resolved.
    }
    mapping(bytes32 => DataAssertion) public assertionsData;
    //event DataAsserted(bytes32 indexed dataId, bytes32 data, address indexed asserter, bytes32 assertionId);

    struct organisation {
         string uri; // extra organisation data that needs to be stored. 
         uint id;
         string ipfs_hash;
         uint stakeAmount;
         bool isGood;
    }
    struct brownie {
        string keyword; // index keyword
        uint256 x; // x times 
        uint256 y; // y number of days 
        bytes intent; // stores the intent of the data used. 
    }
    mapping(address => mapping(uint256 => brownie[])) brownieMaps;
    mapping(address => organisation[]) organisationMaps;
    address ERC20Token;
    uint minAmount;
    mapping(address => uint) brownieCounter;
    address oo;
    OptimisticOracleV3Interface public immutable oo;
    uint64 public constant assertionLiveness = 7200;
    bytes32 public immutable defaultIdentifier;

    constructor(address _erc20, uint _minAmount, address _oo) {
        token = Token(_erc20);
        minAmount = _minAmount;
        oo = _oo;
        defaultIdentifier = oo.defaultIdentifier();
    }

    function createOrganisation(string _uri, uint _id, string _ipfs )
        external
        nonReentrant
        payable
    {
        //require(msg.value > minAmount); check for decimals post hackathon bro
        //console.log("sender address", msg.sender);
        //console.log("balance of sender", token.balanceOf(msg.sender));
        organisationMaps[msg.sender].uri = _uri;
        organisationMaps[msg.sender].stakeAmount = msg.value;
        organisationMaps[msg.sender].id = _id;
        organisationMaps[msg.sender].ipfs_hash = _ipfs;
        organisationMaps[msg.sender].isGood = true;
        brownieCounter[msg.sender] = 0;
       
    }

    function createBrownie(string _intent, string _keyword, uint _x, uint _y) external nonReentrant payable {
         uint256 bond = oo.getMinimumBond(address(defaultCurrency));
         defaultCurrency.safeTransferFrom(msg.sender, address(this), bond);
         //assertionId = oov3.assertTruthWithDefaults(bytes(_intent), address(this));
         assertionId = oo.assertTruth(
            bytes(_intent),
            msg.sender,
            address(this), // Callback recipient
            address(0), // No sovereign security.
            assertionLiveness,
            token,
            bond,
            defaultIdentifier,
            bytes32(0) // No domain.
        );
         brownieCounter[msg.sender] = brownieCounter[msg.sender] + 1;
         brownieMaps[msg.sender][brownieCounter[msg.sender]].keyword = _keyword;
         brownieMaps[msg.sender][brownieCounter[msg.sender]].x = _x;
         brownieMaps[msg.sender][brownieCounter[msg.sender]].y = _y;
         brownieMaps[msg.sender][brownieCounter[msg.sender]].intent = _intent;
    }

    function assertionResolvedCallback(bytes32 assertionId, bool assertedTruthfully) public {
        require(msg.sender == address(oo));
        // If the assertion was true, then the data assertion is resolved.
        if (assertedTruthfully) {
            assertionsData[assertionId].resolved = true;
            DataAssertion memory dataAssertion = assertionsData[assertionId];
            //emit DataAssertionResolved(dataAssertion.dataId, dataAssertion.data, dataAssertion.asserter, assertionId);
            // Else delete the data assertion if it was false to save gas.
        } else delete assertionsData[assertionId];
    }
   function assertionDisputedCallback(bytes32 assertionId) public {}
    


}
