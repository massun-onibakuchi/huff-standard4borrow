# Standard API For Borrowing

> This repo is generated from [massun-onibakuchi/hardhat-foundry-template](https://github.com/massun-onibakuchi/hardhat-foundry-template/).

### Features

- [evm-run](https://github.com/zemse/evm-run) (Run EVM code from console or file, on local or mainnet fork)
- [Static Analyzer](.github/workflows/slither.yml) ([Slither](https://github.com/crytic/slither))

## Getting Started

### Requirements

The following will need to be installed. Please follow the links and instructions.

- [Foundry](https://github.com/foundry-rs/foundry)
  - Install Foundry (assuming a Linux or macOS system): `curl -L https://foundry.paradigm.xyz | bash`
  - This will download foundryup. To start Foundry, run: `foundryup`
- Node >= 15
- yarn or npm >= 7

Having Foundry installed locally is not strictly required, but it may be helpful for debugging. See [Docker and Foundry](https://book.getfoundry.sh/tutorials/foundry-docker).

### Quickstart

1. Install dependencies

Once you've cloned and entered into your repository, you need to install the necessary dependencies. In order to do so, simply run:

```shell
yarn install
forge install
```

2. Build

```bash
forge build
```

3. Deploy a mock lending protocol

```bash
forge script --rpc-url=<YOUR_RPC_URL>  script/MockLendingProtocolDeploy.s.sol
```

3. Test

Set environment variable in `.env` file.

```bash
export ETH_RPC_URL='https://eth-mainnet.alchemyapi.io/v2/$YOUR_API_KEY'
forge test -vvv
npx hardhat test
```

And I'll recommend you to setup command completion for `forge` and `cast` command.
For more information on how to use Foundry, check out the [Foundry Github Repository](https://github.com/foundry-rs/foundry/tree/master/forge) or type `forge help` in your terminal.

### Install Libraries

- Install libraries with Foundry which work with Hardhat.
- Libraries are installed in `lib` directory as a git submodule.

```bash
forge install openzeppelin/openzeppelin-contracts # just an example
```

And then update remappings in `foundry.toml`.

```
remappings = [
    "@openzeppelin/=lib/openzeppelin-contracts/",
]
```

This will allow you to import libraries like this:

```solidity
// Instead of import "lib/openzeppelin-contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
```

### Forge Commands

```bash
forge doc # generates docs in ./docs
forge doc --serve # generates docs and serves them on localhost:3000
forge snapshot
forge coverage
```

### Cast Commands

- Use `cast` command which is a swiss army knife for smart contract development.

```bash
cast --help
```

- Runs a published transaction in a local environment and prints the trace.

```bash
cast run <txhash> --rpc-url <rpc-url>
```

## Resources

For more infomation on how to use Foundry features, refer to:

- [forge-std](https://github.com/foundry-rs/forge-std/)
- [cheat codes](https://github.com/foundry-rs/foundry/blob/master/forge/README.md#cheat-codes)
- [Foundry book](https://book.getfoundry.sh/)
