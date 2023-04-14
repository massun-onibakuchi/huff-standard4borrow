# Huff EIP4Borrow

- [README - Solidity contracts](./contracts/README.md): Solidity contracts template `contracts` package

- [README - Common TypeScript utilities](./common-ts/README.md): Common TypeScript utilities `@huff-eip4borrow/common-ts`

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
