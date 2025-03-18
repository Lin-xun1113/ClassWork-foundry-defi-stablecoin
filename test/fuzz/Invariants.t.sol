// SPDX-License-Identifier: MIT

// Have our invariant aka properties

// What are our invariants?

// 1. The total supply of DSC should always be less than the total value of collateral

// 2. Getter view functions should never revert <- evergreen invariant

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Handler} from "./Handler.t.sol";


contract Invariants is StdInvariant, Test {
    DeployDSC deployer;
    DSCEngine dsce;
    HelperConfig config;
    address ethUsdPriceFeed;
    address wbtcUsdPriceFeed;
    address weth;
    address wbtc;
    DecentralizedStableCoin dsc;
    Handler handler;


    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (, , weth, wbtc,) = config.activeNetworkConfig();
        handler = new Handler(dsce, dsc);
        targetContract(address(handler));
    }

    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        // get the value of all the collateral in the protocol
        // compare it to all the debt (dsc)
        uint256 totalSupply = dsc.totalSupply();
        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
        uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dsce));
        uint256 wethValue = dsce.getUSDValue(weth, totalWethDeposited);
        uint256 wbtcValue = dsce.getUSDValue(wbtc, totalWbtcDeposited);
        console.log("wethValue:", wethValue);
        console.log("wbtcValue:", wbtcValue);
        console.log("Total supply:", totalSupply);
        console.log("Times mint is called:", handler.timesMintIsCalled());
        assert(wethValue + wbtcValue >= totalSupply);
    }

    function invariant_gettersShouldNeverRevert() public view {

    }
}
