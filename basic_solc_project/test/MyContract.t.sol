// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MyContract} from "../src/MyContract.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract MyContractTest is StdInvariant, Test {
    MyContract exampleContract;

    // Initialize the contract before each test
    function setUp() public {
        exampleContract = new MyContract();
        // Tell Forge to automatically call functions on this contract for invariant testing
        targetContract(address(exampleContract));
    }

    // Unit Test: Fixed input testing
    // Tests with one specific data point only
    function testAlwaysGetZeroUnit() public {
        uint256 data = 0;
        exampleContract.doStuff(data);
        assert(exampleContract.shouldAlwaysBeZero() == 0);
    }

    // Stateless Fuzz Testing
    // Forge randomly generates various uint256 values as inputs
    // Each call is independent with fresh state
    function testAlwaysGetZeroFuzz(uint256 data) public {
        exampleContract.doStuff(data);
        assert(exampleContract.shouldAlwaysBeZero() == 0);
    }

    // Stateful Fuzz Testing
    // Multiple sequential calls where state persists between calls
    // Discovers bugs that require specific execution sequences to expose
    function testAlwaysGetZeroStateful() public {
        uint256 data = 7;
        exampleContract.doStuff(data);
        assert(exampleContract.shouldAlwaysBeZero() == 0);

        data = 0;
        exampleContract.doStuff(data);
        assert(exampleContract.shouldAlwaysBeZero() == 0); // This will fail
    }

    // Invariant Testing: The strongest fuzz testing method
    // Forge automatically calls doStuff() with random sequences of random inputs
    // This assertion must ALWAYS hold true, no matter what sequence Forge tries
    // Fails when it finds ANY sequence that violates the invariant
    function invariant_testAlwaysIsZero() public {
        assert(exampleContract.shouldAlwaysBeZero() == 0);
    }
}
