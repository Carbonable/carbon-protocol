<div align="center">
  <h1 align="center">Carbon Protocol on Starknet</h1>
  <p align="center">
    <a href="https://discord.gg/zUy9UvB7cd">
        <img src="https://img.shields.io/badge/Discord-6666FF?style=for-the-badge&logo=discord&logoColor=white">
    </a>
    <a href="https://twitter.com/intent/follow?screen_name=Carbonable_io">
        <img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white">
    </a>       
  </p>
  <h3 align="center">Carbonable contracts written in Cairo for StarkNet.</h3>
</div>

## Usage

> ## ⚠️ WARNING! ⚠️
>
> This repo contains highly experimental code.
> Expect rapid iteration.
> **Use at your own risk.**

### Set up the project

#### 📦 Install the requirements

- [protostar](https://github.com/software-mansion/protostar)

### 🎉 Install

```bash
protostar install
```

### ⛏️ Compile

```bash
protostar build
```

### 🌡️ Test

```bash
# Run all tests
protostar test

# Run only unit tests
protostar test tests/units

# Run only integration tests
protostar test tests/integrations
```

### 🌐 Test account

If you want a fresh account for tests, you can deploy an account with the following command:

```bash
starknet deploy_account --network=<network>
```

It will generate the account information into the `~/.starknet_accounts/starknet_open_zeppelin_accounts.json` file.  
See also starknet [documentation](https://www.cairo-lang.org/docs/hello_starknet/account_setup.html#creating-an-account) for more details.

### 💋 Format code

```bash
cairo-format -i src/**/*.cairo tests/**/**/*.cairo
```

### 📝 Documentation

#### Requirements

- python environment (python >=3.9)
- [`mdutils`](https://pypi.org/project/mdutils/) dependency installed
- [`kaaper-cli`](https://github.com/onlydustxyz/kaaper) installed
- [`thoth`](https://github.com/FuzzingLabs/thoth) installed

#### Generation

```bash
cd docs
kaaper generate ../src ./data
python build.py
callgraphs.sh
```

## 🚀 Deployment

See [How to deploy Carbonable Protocol](https://carbonable.notion.site/How-to-deploy-Carbonable-Protocol-099b947ee1c74ff0923bbcf2178b5979)

### Inputs

To manage inputs sent to constructor during the deployment, you can customize the [config files](./scripts/configs/).

### Prepare the contracts before tests

After deployment, the **admin** account (according to parameters) is the owner of all contracts.
So far, you have to do the following actions manually:

- Change the NFT contract owner from **admin** to **Minter contract**
  - How: _Voyager > Write contract > `transferOwnership`_
  - Verify: _Voyager > Read contract > `owner`_
- Approve the **Minter contract** to spend the **admin payment tokens**
  - How: Voyager > _Write contract > `approve`_
  - Verify: Voyager > _Read contract > `allowance`_
- Buy NFT through the **Minter contract**
  - How: _Voyager > Write contract > `buy`_
  - Verify: _Voyager > Read contract > `balanceOf` (of the NFT contract)_

## 📄 License

**carbonable-starknet-protocol** is released under the [MIT](LICENSE).
