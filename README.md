# Balot NFT

> A radical new model turns the NFT into a tool for decolonization.

## Deploying Minter.sol to the Rinkeby test network

```bash
chmod +x ./scripts/deploy_rinkeby.sh
./scripts/deploy_rinkeby.sh
```

## Contracts

- Mainnet
  - Gnosis Safe [xF078544e774Faf5D10dD04C43F443A80C917C49c](https://gnosis-safe.io/app/eth:0xF078544e774Faf5D10dD04C43F443A80C917C49c/)
  - Collection [0x6b877dfaf74b22913a494d1fc95d7e30c2b88ea1](https://etherscan.io/address/0x6b877dfaf74b22913a494d1fc95d7e30c2b88ea1)
  - Minter [0xf478aF3BD5fdEF9e300E8E62C0429721086C369a](https://etherscan.io/address/0xf478aF3BD5fdEF9e300E8E62C0429721086C369a)
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
- Install the dev node packages using node and npm versions as specified
  in package.json

```bash
git clone git@github.com:whitecube-online/balot.git
forge install
npm ci --include=dev
forge test
npx hardhat test
```

## Changelog

### 0.0.1

- Initial mainnet deployment

## License

See the LICENSE file.
