# Decentralized Stablecoin (DSC)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

## Project Overview

This is a decentralized stablecoin system developed using Solidity and the Foundry framework. The stablecoin has the following characteristics:

1. **USD-Pegged**: 1 DSC = 1 USD
2. **Overcollateralized**: The system always maintains an overcollateralized state, where the value of all collateral must exceed the value of all minted DSC
3. **Algorithmically Stable**: Stability is automatically maintained through smart contracts
4. **Exogenously Collateralized**: Uses ETH and BTC as collateral
5. **No Governance**: The system is designed to be minimal, requiring no governance mechanism
6. **No Fees**: The system does not charge any fees

This project is similar to DAI, but without governance mechanisms, without fees, and backed only by WETH and WBTC as collateral.

## System Architecture

The project contains two main contracts:

1. **DecentralizedStableCoin (DSC)**: An ERC20 token implementation representing the stablecoin itself
2. **DSCEngine**: The core logic contract handling collateral deposits/withdrawals, stablecoin minting and redemption, liquidations, and more

Additionally, the project includes:

- **OracleLib**: Used to interact with Chainlink price feeds, retrieve price data, and check if prices are stale
- **Fuzz Testing**: Ensures system security and stability under various conditions

## Features

- **Deposit Collateral**: Users can deposit ETH or BTC as collateral
- **Mint Stablecoin**: Users can mint DSC based on their collateral value
- **Redeem Collateral**: Users can burn DSC to redeem their collateral
- **Liquidation Mechanism**: When a user's health factor falls below the threshold, other users can liquidate their position
- **Price Oracles**: Uses Chainlink price feeds to get real-time price data
- **Health Factor**: The system monitors users' collateralization ratio through a health factor

## Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/downloads)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/foundry-defi-stablecoin.git
cd foundry-defi-stablecoin

# Install dependencies
forge install

# Compile contracts
forge build
```

### Testing

```bash
# Run all tests
forge test

# Run specific tests
forge test --match-contract DSCEngineTest

# Run fuzz tests
forge test --match-contract Invariants
```

### Deployment

```bash
# Deploy to local network
forge script script/DeployDSC.s.sol --rpc-url http://localhost:8545 --broadcast

# Deploy to Sepolia testnet
forge script script/DeployDSC.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

## Contract Interaction

### Deposit Collateral and Mint DSC

```solidity
// Deposit collateral
dscEngine.depositCollateral(tokenCollateralAddress, amountCollateral);

// Mint DSC
dscEngine.mintDsc(amountDscToMint);

// Deposit collateral and mint DSC in one step
dscEngine.depositCollateralAndMintDsc(tokenCollateralAddress, amountCollateral, amountDscToMint);
```

### Redeem Collateral

```solidity
// Redeem collateral
dscEngine.redeemCollateral(tokenCollateralAddress, amountCollateral);

// Burn DSC and redeem collateral
dscEngine.redeemCollateralForDsc(tokenCollateralAddress, amountCollateral, amountDscToBurn);
```

### Liquidate Unhealthy Positions

```solidity
dscEngine.liquidate(tokenCollateralAddress, user, debtToCover);
```

## Security Considerations

- The system is designed to always maintain an overcollateralized state (200%)
- Uses reentrancy guards to prevent reentrancy attacks
- Price oracle timeout checks to prevent using stale prices
- Comprehensive unit tests and fuzz tests to ensure system stability under various conditions

## Project Structure

```
foundry-defi-stablecoin/
├── src/                    # Source code
│   ├── DSCEngine.sol       # Core logic contract
│   ├── DecentralizedStableCoin.sol  # ERC20 stablecoin implementation
│   └── libraries/          # Libraries
│       └── OracleLib.sol   # Oracle library
├── script/                 # Deployment scripts
│   ├── DeployDSC.s.sol     # Deployment script
│   └── HelperConfig.s.sol  # Configuration helper
├── test/                   # Tests
│   ├── fuzz/               # Fuzz tests
│   │   ├── Handler.t.sol   # Fuzz test handler
│   │   └── Invariants.t.sol # Invariant tests
│   ├── mocks/              # Mock contracts
│   └── uint/               # Unit tests
└── foundry.toml            # Foundry configuration
```

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

## License

[MIT](LICENSE)

## Acknowledgements

- Thanks to Patrick Collins for guidance through his Solidity course
- Thanks to IIIu_23 for translating the Solidity course, making it more accessible
- Thanks to Chainlink for providing price oracle services
