# Fuzzing: Concepts & Techniques

## I. What is Fuzzing?

Fuzzing is an automated testing technique based on a simple idea:

**"Feed a system random, strange, and unexpected data to see if it breaks."**

### Example

Consider this smart contract function:

```solidity
function deposit(uint256 amount) external {
    require(amount > 0, "amount must > 0");
    balance[msg.sender] += amount;
}
```

**Normal inputs:** `100`, `50`, `9999`

**Fuzzing inputs:** 
- `0`
- `2^256 - 1`
- `-1` (overflow)
- Oversized strings, empty inputs, unexpected types

**Fuzzing checks for:**
- Panics, reverts, or overflows
- Uncovered edge cases
- Logic anomalies (e.g., negative balances)

---

## II. Stateless Fuzzing

Stateless fuzzing treats each test input independently with no memory of previous state.

### How It Works

Every test starts from scratch:

```
Test 1:  deposit(0)
Test 2:  deposit(999999999999)
Test 3:  deposit(2^256 - 1)
Test 4:  deposit(invalid_type)
...
```

### Advantages
- Simple and fast
- Good for unit-level testing

### Limitations
- Cannot detect bugs requiring multi-step interactions
- Misses complex vulnerabilities like re-entrancy or cross-function state issues

---

## III. Stateful Fuzzing

Stateful fuzzing is more intelligent: it feeds random data while simulating continuous interactions and preserving state.

### How It Works

Instead of testing functions in isolation, it chains multiple calls:

**Sequence 1:**
```
Step 1: deposit(100)
Step 2: withdraw(200)
```

**Sequence 2:**
```
Step 1: deposit(50)
Step 2: deposit(70)
Step 3: withdraw(60)
```

The fuzzer remembers balances, account states, and contract variables throughout.

### Advantages
- Discovers vulnerabilities requiring multiple interactions
- Ideal for re-entrancy, ordering issues, and asset anomalies
- Better for DeFi protocols, AMMs, lending contracts, and bridge logic

### Use Cases
- Detecting re-entrancy attacks
- Finding state management flaws
- Testing complex protocol interactions

---

## IV. Invariants & Properties

Fuzzing alone just "throws random inputs." To determine if the system breaks, you must define what cannot be broken: **Invariants** or **Properties**.

Invariants are the **physical laws** of your system—rules that must always remain true, no matter what operations are performed.

### Common Invariants

| Invariant | Meaning |
|-----------|---------|
| `totalSupply == sum(userBalances)` | Total supply equals sum of all user balances |
| `collateral >= debt` | Collateral value must exceed debt |
| `poolReserves >= 0` | Pool reserves cannot be negative |
| `price(tokenA) × price(tokenB) = constant` | For AMM testing |

### How It Works

Fuzzing frameworks (Foundry, Echidna) continuously ask:

**"Can we break this invariant through random operations?"**

If the framework discovers `totalSupply ≠ sum(balances)`, it has found a logic vulnerability.

---

## V. Real-World Analogy

| Concept | Real-World Analogy | Explanation |
|---------|-------------------|-------------|
| **Stateless Fuzzing** | Throwing stones at a glass cup repeatedly | Each test is independent; checking if the cup breaks under single impacts |
| **Stateful Fuzzing** | Pouring water into a cup, cooling it, heating it | Simulating a sequence of operations; checking if the cup survives the entire process |
| **Invariants** | Physical laws of the cup | "Must hold water," "cannot leak"—rules the system must always obey |
| **Property-based Testing** | Testing a rule like "volume increases with temperature" | Verifying functions and protocols follow their logical rules consistently |

---

## VI. Summary

| Term | Definition |
|------|-----------|
| **Fuzzing** | Continuously feeding random inputs to break the system |
| **Stateless Fuzzing** | Each test is independent; good for single-function testing |
| **Stateful Fuzzing** | Simulating continuous interactions; catches multi-step vulnerabilities |
| **Invariants/Properties** | Rules the system must always satisfy—the foundation of effective fuzzing |

By combining stateful fuzzing with well-defined invariants, you create a powerful automated testing system that catches subtle bugs before they reach production.

---

## VII. Getting Started

**Popular Fuzzing Tools:**
- **Foundry** — Ethereum smart contract testing framework with invariant testing
- **Echidna** — Specialized fuzzing tool for Solidity contracts
- **Hypothesis** — Python property-based testing library
- **libFuzzer** — General-purpose fuzzing engine

Start with defining your invariants first, then design your stateful fuzzing scenarios around them.
