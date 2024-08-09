// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkconfig;

    struct NetworkConfig {
        address priceFeed; // ETHUSD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkconfig = getSepoliaEthConfig();
        } else {
            activeNetworkconfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaconfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaconfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);

        vm.stopBroadcast();

        NetworkConfig memory anvilconfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilconfig;
    }
}
