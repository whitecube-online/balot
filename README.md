# Balot NFT

> A radical new model turns the NFT into a tool for decolonization.

## Deploying

1. Find open RPC interfaces by visiting: https://ethereumnodes.com and set
   `ETH_RPC_URL`.
2. In `.sethrc`, change `ETH_FROM` to current account
3. With
   [`web3-eth-accounts`](https://web3js.readthedocs.io/en/v1.2.11/web3-eth-accounts.html#web3-eth-accounts)
   create keystore3 JSON and copy into `keys.json` file.
4. Execute the command below:

```bash
dapp create Balot <constructor nextOwner, baseURI> --verify
```

Note: String arguments have to be double quoted in bash, e.g., `'"hello world"'`

5. In case verification fails in deploy step, it can later be done too.

```bash
dapp verify-contract ./src/Balot.sol:Balot <contract addr> "<constructor nextOwner, baseURI>"
```

Another option to get the contract code verified by Etherscan is by flattening
the file with `hevm`:

```bash
hevm flatten --source-file src/Balot.sol > out/Balot.sol
```

`Balot.sol` can then just be uploaded through Etherscan's web form.

## Contracts

- Mainnet
  - Gnosis Safe [xF078544e774Faf5D10dD04C43F443A80C917C49c](https://gnosis-safe.io/app/eth:0xF078544e774Faf5D10dD04C43F443A80C917C49c/)
  - Collection [0x6b877dfaf74b22913a494d1fc95d7e30c2b88ea1](https://etherscan.io/address/0x6b877dfaf74b22913a494d1fc95d7e30c2b88ea1)
- Goerli
  - Gnosis Safe: [0x54385C523B4F71C3a61F739109635aFCe63E6db2](https://gnosis-safe.io/app/gor:0x54385C523B4F71C3a61F739109635aFCe63E6db2)
  - Collection: [0x63eb4debc3d15460b0cc187efdb6d799b2606096](https://goerli.etherscan.io/address/0x63eb4debc3d15460b0cc187efdb6d799b2606096)
- Rinkeby
  - Gnosis Safe: [0xdCC1479F2A0925990eC507b38866a522F0F5EF87](https://rinkeby.etherscan.io/address/0xdCC1479F2A0925990eC507b38866a522F0F5EF87), [app](https://gnosis-safe.io/app/rin:0xdCC1479F2A0925990eC507b38866a522F0F5EF87/balances)
  - Collection: [0x96fe86e5cbb3f01a9ce079ac884469049d7cbb39](https://rinkeby.etherscan.io/address/0x96fe86e5cbb3f01a9ce079ac884469049d7cbb39)

## Notes

- Inheritance scheme inspired by OpenZeppelin's [contract
  wizard](https://wizard.openzeppelin.com/#erc721).

## Contributing & Testing

- It's required you have [`foundry`](https://github.com/foundry-rs/foundry)
  installed.

```bash
git clone git@github.com:whitecube-online/balot.git
forge install
forge test
```

## Changelog

### 0.0.1

- Initial mainnet deployment

## License

See the LICENSE file.
