# Balot NFT

- Latest launch date: Feb 8, 2022
- [Specification](https://docs.google.com/document/d/1xcrt-IvdNDHR1ILPCJ9V8yAFNO_hw3mbKMqC432h_VY/edit#heading=h.6gku1k5aweci)

## Deploying

To find open RPC interfaces, visit:

- https://ethereumnodes.com/

```bash
dapp create Balot <constructor nextOwner> --verify
```

```bash
dapp verify-contract ./src/Balot.sol:Balot <contract addr> "<constructor nextOwner>"
```

## Contracts

- Goerli
  - Gnosis Safe: [0x54385C523B4F71C3a61F739109635aFCe63E6db2](https://gnosis-safe.io/app/gor:0x54385C523B4F71C3a61F739109635aFCe63E6db2/balances)
  - Collection: [0x63eb4debc3d15460b0cc187efdb6d799b2606096](https://goerli.etherscan.io/address/0x63eb4debc3d15460b0cc187efdb6d799b2606096)
- Rinkeby
  - Gnosis Safe: [0xdCC1479F2A0925990eC507b38866a522F0F5EF87](https://rinkeby.etherscan.io/address/0xdCC1479F2A0925990eC507b38866a522F0F5EF87)
  - Collection: [0x067f891E26dC029cC72D2c6c9750c9fa4C227840](https://rinkeby.etherscan.io/address/0x067f891E26dC029cC72D2c6c9750c9fa4C227840)

## Notes

- Inheritance scheme inspired by OpenZeppelin's [contract
  wizard](https://wizard.openzeppelin.com/#erc721).


## Contributing

- It's required you have [`dapptools`](https://github.com/dapphub/dapptools)
  installed.
- Clone the repository and e.g. run the tests.

## Testing

The contracts are tested using `dapp`. To run them, call:

```bash
dapp test
```

## License

See the LICENSE file.
