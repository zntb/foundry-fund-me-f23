// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkconfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed; // ETHUSD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkconfig = getSepoliaEthConfig();
        } else {
            activeNetworkconfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaconfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaconfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkconfig.priceFeed != address(0)) {
            return activeNetworkconfig;
        }
        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );

        vm.stopBroadcast();

        NetworkConfig memory anvilconfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilconfig;
    }
}
