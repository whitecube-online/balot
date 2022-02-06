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
