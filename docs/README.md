# Standard for borrowing

## Background and Concept

### The foundation for the explosive growth of DeFi

The ERC20 standard was proposed in November 2015 and finalized as an EIP in September 2017.

It was created to ensure standardization of tokens on the Ethereum blockchain, allowing for seamless exchange between different token types and platforms.

It paved the way for ICOs and the explosion of the decentralized finance (DeFi) ecosystem.

### DeFi's Rapid Growth in 2020

The DeFi ecosystem has seen tremendous growth in 2020, as ERC20 tokens enable a wide range of applications. These tokens have facilitated liquidity staking, governance, lending, and sharing of liquidity pools.

DeFi's rapid growth is due in large part to the composability of its protocols. This feature allows developers to combine different DeFi protocols to create new use cases and applications. Protocols such as Instadapp, Yearn Finance, and Convex Finance have built on top of other DeFi protocols, demonstrating the power of composability.

Yearn Finance, for example, has combined Aave, Compound, Uniswap and so on to create a single protocol that enables users to earn interest on their assets efficiently and semi-automatically.

In this context, _ERC4626_ plays a key role in the growth of DeFi. It is a standard for interest bearing tokens and lending. It is designed to be easily integrated into other DeFi protocols and applications.

### Now, we need a standard for borrowing

ERC4626 is a standard for lending. However, it does not cover borrowing. Why don't we need a standard for borrowing?

Last year the DeFi ecosystem has seen some products that utilize borrowing.

For example Instadapp released a powerful product called Leveraged Yield Strategy. The stETH Vault takes stETH deposits and supplies it to various lending protocols, borrows ETH for more stETH to achieve a leveraged position and increased interest rates. Supported protocols include Aave, Compound, and Morpho.

But Each lending protocol implement its own way. This makes it difficult for developers to integrate borrowing into their applications and protocols. The standard will encourage the development of more composed DeFi and allow developers to easily integrate borrowing into their applications and protocols. And the standard makes borrowing accessible to users and easy to use. The introduction of the standard is a crucial next step in the growth of DeFi.

# A Standard API for borrowing

## Proposed design

1. Extend ERC4626 to support borrowing.
2. Create a new standard for lending and borrowing for multiple ERC20 tokens. This standard will be un-compatible with ERC4626 and does not require any existing standard.

## Pro/Con

1. Extend ERC4626 to support borrowing

   - Pro
     - Easier to implement than option 2.
     - Extend existing standard (ERC4626). Comunnity might easily understand and adopt.
     - Compatible with existing protocols (Morpho, Compound V2)
   - Con
     - Somewhat compatible with some existing protocols (Aave, Compound, etc.)
       - Aave and Compound V3 have a single entry point for lending and borrowing. In this case, a wrapper contract for each interest bearing token is required to comply with this standard. If protocol manages multiple interest bearing tokens, it will be tricky.
     - Debt token is not the contract that implements this standard. The contract implementing this standard is the interest bearing token. (like cToken)

2. Create a new standard for lending and borrowing for multiple ERC20 tokens.

   - Pro
     - Highly compatible with existing protocols (Aave, Compound, Euler, etc.)
     - Some function is not compatible with existing protocols (Morpho, Compound V2)
   - Con

     - Independent with ERC4626.

Issue:

- Compound V2 and Morpho doesn't support credit delegation which allows a delegated account to borrow on behalf of the collateral owner. Maybe Wrapper contracts for these can't work with this standard when users want to borrow.

## Standard API for borrowing vs ERC4626

ERC4626: A standard API for tokenized Vaults representing shares of a single underlying ERC20 token.

Standard for borrowing: A standard API for lending and borrowing multiple ERC20 tokens.

|     |     |
| --- | --- |
|     |     |
|     |     |

## Reference

Compound V3: https://docs.compound.finance/

Aave V3: https://docs.aave.com/developers/getting-started/readme

## Dev

To modify diagrams, open in diagrams.net (formerly draw.io) and save both file and svg. Export svg with settings Zoom: 100% and Border Width: 5.
