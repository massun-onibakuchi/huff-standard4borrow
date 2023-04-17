# Huff EIP4Borrow

- [README - Solidity contracts](./contracts/README.md): Solidity contracts template `contracts` package

### Requirements

- Node.js >= 15
- yarn and npm >= 7
- [foundry](https://book.getfoundry.sh/)

## Quick Start

Install dependencies

```bash
yarn
cd contracts && forge install
# If `forge install` doesn't work correctly, try the following command for each .gitmodules in contracts directory.
# e.g forge install https://github.com/openzeppelin/openzeppelin-contracts
```

Each package has its own README. See the following links for more details.

[Build Solidity contracts](./contracts/README.md)

## Development

```
yarn build  # build all packages
yarn build:contracts  # build contracts
yarn build:ts  # build typescript packages
yarn test   # run all tests
yarn lint:check   # run all linters
yarn lint:fix   # run all linters
```

## Chains we deployed our BorrowFi Aggregator contract
For all deployments, we used an address "0x777708eD0dA60151731363f36C14218005Bce4d1" to submit transactions.
### Polygon
- BorrowFiAggregator
  - https://mumbai.polygonscan.com/address/0x5ef22a113f88b05038021b248f12944acea06c02
  - https://twitter.com/_cotoneum_/status/1647358425842737153?s=20
- AaveV3Market (borrowing wrapper for AaveV3)
  - https://mumbai.polygonscan.com/address/0x8A0f53461463c535Ce666f16596e9470069678C5
  - https://twitter.com/_cotoneum_/status/1647381381608099840?s=20
- MockLendingProtocol (borrowing wrapper for MockERC20)
  - https://mumbai.polygonscan.com/address/0x13Bd7d095212bcfDC0F719840F7Cc26eA7F40CcB
  - https://twitter.com/_cotoneum_/status/1647381876858814467?s=20

### Scroll
- BorrowFiAggregator
  - https://blockscout.scroll.io/address/0x5EF22a113F88B05038021b248F12944ACeA06c02
- AaveV3Market (borrowing wrapper for AaveV3)
  - https://blockscout.scroll.io/address/0x8A0f53461463c535Ce666f16596e9470069678C5
- MockLendingProtocol (borrowing wrapper for MockERC20)
  - https://blockscout.scroll.io/address/0x13Bd7d095212bcfDC0F719840F7Cc26eA7F40CcB
### Celo-alfajores
- BorrowFiAggregator
  - https://alfajores.celoscan.io/address/0x5ef22a113f88b05038021b248f12944acea06c02
- AaveV3Market (borrowing wrapper for AaveV3)
  - https://alfajores.celoscan.io/address/0x8A0f53461463c535Ce666f16596e9470069678C5
- MockLendingProtocol (borrowing wrapper for MockERC20)
  - https://alfajores.celoscan.io/address/0x13Bd7d095212bcfDC0F719840F7Cc26eA7F40CcB
### Ethereum Goerli
- BorrowFiAggregator
  - https://goerli.etherscan.io/address/0x6cc8e62c62b5c534f65c3d026051caa84bbc112f
- AaveV3Market (borrowing wrapper for AaveV3)
  - https://goerli.etherscan.io/address/0x95b1b526fdd7851cfa836602b1c621ebf77bccf9
- MockLendingProtocol (borrowing wrapper for MockERC20)
  - https://goerli.etherscan.io/address/0xB0Bb7349DFb84c5749787678cc5253B33CaF91a7
