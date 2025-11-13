# Foundry Smart Contract Testing Guide

## Overview

Foundry is a Solidity testing framework that supports both **unit tests** and **fuzz tests**. The Counter project demonstrates basic contract testing patterns.

## Project Structure

### Core Contracts

- **Counter.sol**: A simple contract with `setNumber()` and `increment()` functions
- **Counter.t.sol**: Test suite with unit and fuzz tests
- **Counter.s.sol**: Deployment script template
- **foundry.toml**: Configuration file for Foundry settings

## Essential Commands

### Project Initialization & Building

```bash
forge init              # Initialize a new Foundry project
forge build             # Compile Solidity contracts
```

### Testing

```bash
forge test              # Run all tests
forge test --mt testFuzz_SetNumber  # Run specific test by name (--mt = match test)
```

## Test Types

### Unit Tests

- **Function**: `test_Increment()`
- **Purpose**: Tests a specific scenario with fixed inputs
- **Example**: Increments counter from 0 to 1

```solidity
function test_Increment() public {
    counter.increment();
    assertEq(counter.number(), 1);
}
```

### Fuzz Tests

- **Function**: `testFuzz_SetNumber(uint256 x)`
- **Purpose**: Tests contract behavior with randomized inputs
- **Range**: Generates 600 random `uint256` values by default
- **Benefit**: Discovers edge cases and unexpected behaviors

```solidity
function testFuzz_SetNumber(uint256 x) public {
    counter.setNumber(x);
    assertEq(counter.number(), x);
}
```

## Configuration: foundry.toml

Key fuzz testing settings:

```toml
[fuzz]
runs = 600                    # Number of random test cases
max_test_rejects = 65536      # Max rejections before failing
seed = '0x3e8'                # Reproducible randomness
dictionary_weight = 40        # Weight for dictionary-based fuzzing
include_storage = true        # Include storage slots in fuzzing
include_push_bytes = true     # Include push bytes in fuzzing
```

Modify `runs` to control how many random inputs are tested.

## Test Execution Example

```bash
$ forge test --mt testFuzz_SetNumber
[PASS] testFuzz_SetNumber(uint256) (runs: 600, μ: 28957, ~: 29289)
Suite result: ok. 1 passed; 0 failed; 0 skipped
```

- **runs: 600**: 600 random test cases executed
- **μ (mu)**: Average gas consumption
- **~**: Median gas consumption

## Workflow

1. **Initialize**: `forge init`
2. **Develop**: Write contract code in `src/`
3. **Test**: Write tests in `test/`
4. **Build**: `forge build`
5. **Run Tests**: `forge test`
6. **Debug**: Use `--mt` flag to isolate specific tests

## Key Takeaways

- **Unit tests** verify specific scenarios with predetermined inputs
- **Fuzz tests** discover vulnerabilities by testing with hundreds of random inputs
- **foundry.toml** controls fuzz behavior (runs, seed, dictionary options)
- Fuzz tests are ideal for testing mathematical properties and edge cases
