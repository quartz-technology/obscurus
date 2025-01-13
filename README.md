# <h1 align="center"> Obscurus </h1>

<p align="center">
    <img src=".github/assets/README_ILLUSTRATION.png" style="border-radius:5%" width="800" alt="">
</p>

<p align="center">
    Anonymous K/M signature scheme for Safe Wallet, built using Semaphore and Zodiac.
</p>

## Table of Contents

- [Disclaimer](#disclaimer)
- [Introduction](#introduction)
  - [Concept](#concept)
  - [Goal](#goal)
  - [Details](#details)
- [Acknowledgements](#acknowledgments)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Using Anvil Fork](#using-anvil-fork)
    - [1. Fork a network](#1-fork-a-network)
    - [2. Depliy a Safe Wallet](#2-deploy-a-safe-wallet)
    - [3. Deploy Obscurus](#3-deploy-obscurus)
    - [4. Approve a transaction](#4-approve-a-transaction)
    - [5. Execute a transaction](#5-execute-a-transaction)
    - [6. Invalid transactions](#6-invalid-transactions)
- [Contributing](#contributing)
- [Authors](#authors)

## Disclaimer

This project is currently in its early development stages and is not production-ready.
It is provided "as-is" with limited functionality and definitely contain bugs or incomplete features.
Users must exercise caution when using it, as critical features or optimizations required for production environments are missing.

We encourage testing and experimentation in non-production local environments and welcome feedback to improve the project.
However, please refrain from deploying it to live networks until it has reached a stable release version.

Use at your own risk.

## Introduction

### Concept

Obscurus is a Zodiac Module (a plugin) that can be attached to a Safe multi-signature Wallet, which provides an alternative to the default mechanism for verifying signatures to approve and execute transactions.
With Obscurus, a group of anonymous owners, referred to as identities, are controlling the multisig.
When transactions are approved, nobody can know which one of the identities made the approval, but with the following guarantees:
- It is indeed a member of this group.
- A single identity cannot approve a given transaction more than once.

### Goal

The goal of Obscurus is to make the Safe Wallet owners approvals anonymous, while providing the same guarantees of the traditional multisig.

### Details

Usually in a Safe Wallet, K over M (with K <= M) owners are required to approve and execute a transaction from the multisig.
Zodiac Modules contain additional logic that can be plugged-in to a Safe Wallet which have the interesting property of being able to bypass the traditional flow of approval and execution.
The owners signatures are not required anymore, and any arbitrary transaction can be executed by the Safe Wallet via the Zodiac Module.

Here with Obscurus, we combine this Zodiac Module property with the Semaphore framework to give the ability to the owners to prove their membership and send transaction approvals without revealing their original identity.

More information about Zodiac Modules are available in:

- [The Safe Wallet documentation](https://docs.safe.global/advanced/smart-account-modules).
- [The Zodiac documentation](https://www.zodiac.wiki/documentation).

More information about the Semaphore framework are available in:

- [The official Semaphore documentation](https://docs.semaphore.pse.dev/).

## Acknowledgements

We wanted to thank the following entities / persons for their precious help. This project would not exist without their contributions and solutions:

- [Safe](https://safe.global/). This project relies on the Safe Wallet, so it is obvious that they deserve a praise.
- [Zodiac](https://zodiac.wiki/). Extra-logic on Safe Wallets can only be achieved via Zodiac Modules.
- [Colin Nielsen](https://github.com/colinnielsen). We used [safe-tools](https://github.com/colinnielsen/safe-tools) to test Obscurus, and its design is partially inspired by [dark-safe](https://github.com/colinnielsen/dark-safe). Go ahead and take a look at Colin's projects, they're amazing.
- [PSE](https://pse.dev/). Obscurus would have been much more difficult to develop if it was not without Semaphore, the framework built by the PSE team.

## Getting Started

This section is here to help you deploy and use Obscurus.
Please note that for the moment, the only documented way to deploy the project is on a local network, using Anvil.

### Prerequisites

Before you can deploy and use Obscurus, you must install a few tools:
- [Docker](https://docs.docker.com/engine/install/).
- [Foundry](https://book.getfoundry.sh/getting-started/installation).

Once installed, you can go ahead and follow the steps to deploy and use Obscurus using one of the available methods.

### Using Anvil Fork

Anvil let's you fork a network to deploy and interact with the Obscurus smart contracts.
You will deploy a Safe Wallet owned by a single address, deploy and attach Obscurus to it, owned by 3 entities (Alice, Bob and Pierre) and execute anonymously approved transactions in the Safe Wallet via the Obscurus Module.

For future reference, here are the values for the identities of Alice, Bob and Pierre. You can think of those as the Ethereum public addresses, but in the context of Semaphore:

- Alice: `16154315983106457604964519632507479861508345150261468393750536759701116467867`
- Bob: `12241487482047535455927935140249225031445150086629846794755977920490270273737`
- Pierre: `15899159344494353576723282793888645985869881307160044049094584250085609856278`

Each one of the 3 members has a private key used to generate a ZKP to approve the transactions anonymously:

- Alice: `zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM=`
- Bob: `QigfrBOzbDNxo9Y7aJQoY52OSwsdOuEtnFvKFaPaG4g=`
- Pierre: `h2QBqQRh1ecKCDWzQX1Pt8w2zAK/QwKANcMJA6nQeRs=`

#### 1. Fork a network

To fork a network, use the following command and replace `<YOUR_RPC_URL>` with a real RPC endpoint.
Here, we will fork Holesky.
```shell
anvil -f <YOUR_RPC_URL> --auto-impersonate
```

#### 2. Deploy a Safe Wallet

Using the official Safe CLI tool, you can deploy a Safe using one of the Anvil default account as the owner:
```shell
docker run -it safeglobal/safe-cli safe-creator http://host.docker.internal:8545 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

Here, `0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80` is the private key of one of the default account pre-funded in Anvil.

You should get an output similar to this one:
```shell
 ____           __          ____                     _
/ ___|   __ _  / _|  ___   / ___| _ __   ___   __ _ | |_   ___   _ __
\___ \  / _` || |_  / _ \ | |    | '__| / _ \ / _` || __| / _ \ | '__|
 ___) || (_| ||  _||  __/ | |___ | |   |  __/| (_| || |_ | (_) || |
|____/  \__,_||_|   \___|  \____||_|    \___| \__,_| \__| \___/ |_|


Network HOLESKY - Sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 - Balance: 10000.000000Ξ
Creating new Safe with owners=['0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'] threshold=1 salt-nonce=13432527610990583215445046268100408472893264083727515392743572596940086483582
Safe-master-copy=0x29fcB43b46531BcA003ddC8FCB67FFE91900C762 version=1.4.1
Fallback-handler=0xfd0732Dc9E303f09fCEf3a7388Ad10A83459Ec99
Proxy factory=0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67
Do you want to continue? [y/N]: y
Safe will be deployed on 0x43Ca5D81816AA33BfE354438007dCa68224A47AC, looks good? [y/N]: y
Sent tx with tx-hash=0xb2ae7557e52976415293eadb26e01dec1037af65774172ae7743a62b35ebe4a1 Safe=0x43Ca5D81816AA33BfE354438007dCa68224A47AC is being created
Tx parameters={'value': 0, 'gas': 262053, 'maxFeePerGas': 1000000056, 'maxPriorityFeePerGas': 1000000000, 'chainId': 17000, 'from': '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', 'to': '0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67', 'data': '0x1688f0b900000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c76200000000000000000000000000000000000000000000000000000000000000601db28a8c56f33a389a49c81ac21650ba57cede92737c8bab9acf4b5e50909a7e0000000000000000000000000000000000000000000000000000000000000164b63e800d0000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000140000000000000000000000000fd0732dc9e303f09fcef3a7388ad10a83459ec990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'nonce': 1010}
EthereumTxSent(tx_hash=HexBytes('0xb2ae7557e52976415293eadb26e01dec1037af65774172ae7743a62b35ebe4a1'), tx={'value': 0, 'gas': 262053, 'maxFeePerGas': 1000000056, 'maxPriorityFeePerGas': 1000000000, 'chainId': 17000, 'from': '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', 'to': '0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67', 'data': '0x1688f0b900000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c76200000000000000000000000000000000000000000000000000000000000000601db28a8c56f33a389a49c81ac21650ba57cede92737c8bab9acf4b5e50909a7e0000000000000000000000000000000000000000000000000000000000000164b63e800d0000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000140000000000000000000000000fd0732dc9e303f09fcef3a7388ad10a83459ec990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'nonce': 1010}, contract_address='0x43Ca5D81816AA33BfE354438007dCa68224A47AC')
```

Copy and save the Safe Wallet address. In the example above, it is `0x43Ca5D81816AA33BfE354438007dCa68224A47AC`.

#### 3. Deploy Obscurus

It is now time to deploy the Obscurus Module and attach it to the Safe Wallet you just deployed.
In your terminal, set the following environment variables:
```shell
export RPC_URL=http://localhost:8545
export ODS_SAFE_ADDRESS=0x43Ca5D81816AA33BfE354438007dCa68224A47AC
export ODS_SAFE_OWNER_PK=77814517325470205911140941194401928579557062014761831930645393041380819009408
export ODS_THRESHOLD=2
export ODS_IDENTITY_COMMITMENT_0=16154315983106457604964519632507479861508345150261468393750536759701116467867
export ODS_IDENTITY_COMMITMENT_1=12241487482047535455927935140249225031445150086629846794755977920490270273737
export ODS_IDENTITY_COMMITMENT_2=15899159344494353576723282793888645985869881307160044049094584250085609856278
export ODS_NUM_IDENTITIES=3
```

Here, you will deploy an Obscurus Module with 3 identities (the owners).
Also, the threshold required to execute a transaction is 2, so you will need to provide 2 out of 3 proofs minimum so that the transaction can be executed.

Now run the following command to deploy the module and attach it to the Safe Wallet:
```shell
forge script ./script/Deploy.fork.holesky.s.sol --rpc-url $RPC_URL --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvvv
```

If something went wrong at this step, try removing the `broadcast` and `cache` folders.
Otherwise, you should get a `broadcast/Deploy.fork.holesky.s.sol/17000/run-latest.json` file which contains the Obscurus deployment address.

Copy it and set a new environment variable in your terminal:
```shell
export ODS_OBSCURUS_ADDRESS=0x9c5e1b46cf9d94ec55f8ca6d2075d9dfb988673e
```

You can confirm that the Obscurus module has been enabled (attached) to the Safe by running the following command, which should print `true`:
```shell
cast call $ODS_SAFE_ADDRESS "isModuleEnabled(address)(bool)" $ODS_OBSCURUS_ADDRESS
```

#### 4. Approve a transaction

Before executing a transaction, it must be approved.
In the context of Obscurus, this means that at least K entities (with K being the threshold we defined earlier) must generate proofs.

You can think of those proofs as some kind of commitments over which transaction is approved.
They also prevent double-approval by a unique entity and guarantee membership, so the proof will be invalid if one entity submits two proofs for the same transaction approval or if an entity external to the group submits a proof.

To generate the proofs, run the following commands. Here, the transaction is very simple: it has no calldata, and transfers 0 ETH.
In a real world scenario, the group members generates a proof on their own and they all could send it to a trusted relay for example.
```shell
# Identity 0 is Alice.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-alice.json

# Identity 1 is Bob.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "QigfrBOzbDNxo9Y7aJQoY52OSwsdOuEtnFvKFaPaG4g=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-bob.json
```

#### 5. Execute a transaction

Now that the proofs used to approve the transaction have been generated by the identities, you can execute it using the following command.
This will verify the proofs onchain and require that at least the threshold is respected.
Here the proofs files are named for simplicity but they obviously should not leak the identity of their creators.
Also, the address sending the transaction (`--signer`) is the owner of the Safe Wallet by this could be anyone else:
```shell
npx tsx test/ts-utils/obscurus-cli.ts exec --proofs /tmp/proof-alice.json /tmp/proof-bob.json --signer "0xAC0974BEC39A17E36BA4A6B4D238FF944BACB478CBED5EFCAE784D7BF4F2FF80" --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0
```

Which should print something similar to this:
```shell
{"hash":"0xe6e83eb6d5afa4df26c648b7a370b42d4fc48d5c4a662beeec70e61f23758d0d","result":[true,"0x"]}
```

Well done! The Safe Wallet has executed a transaction which has been proved by the Obscurus Module and does not leak the identity of the members that have approved it in the first place!
In a real world scenario, nothing can link the proofs to their creator and therefore nobody will be able to know who has approved (or restrained from approving) a transaction.

#### 6. Invalid transactions

You can also generate only one proof and try to execute the transaction, it will not work at the threshold is not met:
```shell
# Identity 0 is Alice.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-alice.json

npx tsx test/ts-utils/obscurus-cli.ts exec --proofs /tmp/proof-alice.json --signer "0xAC0974BEC39A17E36BA4A6B4D238FF944BACB478CBED5EFCAE784D7BF4F2FF80" --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0
```

You should get the following error:
```shell
/Users/Developer/obscurus/test/ts-utils/node_modules/viem/utils/errors/getContractError.ts:78
  return new ContractFunctionExecutionError(cause as BaseError, {
         ^
ContractFunctionExecutionError: The contract function "obscureExecAndReturnData" reverted.

Error: NotEnoughProofs()
```

Or, you can also try to temper with one of the generated proof.
Lets try to approve a transaction with 2 entities and corrupt one of them:
```shell
# Identity 0 is Alice.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-alice.json

# Identity 1 is Bob.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "QigfrBOzbDNxo9Y7aJQoY52OSwsdOuEtnFvKFaPaG4g=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-bob.json

##
## Before running the command below, edit the /tmp/proof-alice.json.
## Try replacing one of the nullifier field for example.
##

npx tsx test/ts-utils/obscurus-cli.ts exec --proofs /tmp/proof-alice.json /tmp/proof-bob.json --signer "0xAC0974BEC39A17E36BA4A6B4D238FF944BACB478CBED5EFCAE784D7BF4F2FF80" --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0
```

This will result in the following error:
```shell
/Users/Developer/obscurus/test/ts-utils/node_modules/viem/utils/errors/getContractError.ts:78
  return new ContractFunctionExecutionError(cause as BaseError, {
         ^

ContractFunctionExecutionError: The contract function "obscureExecAndReturnData" reverted with the following signature:
0x4aa6bc40
```

Here, `cast` can help us decode the error:
```shell
cast decode-error 0x4aa6bc40
# Semaphore__InvalidProof()
```

## Contributing

Coming soon.

## Authors

This project is currently being maintained by the folks at [Quartz Technology](https://github.com/quartz-technology).

