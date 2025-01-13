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
- [Getting Started](#getting-started)
  - [Anvil Fork](#anvil-fork)
- [Contributing](#contributing)
- [Authors](#authors)

## Disclaimer

This project is a prototype. It must not be used in a production environment.

## Introduction

Coming soon.

## Getting Started

### Anvil Fork

To deploy and use Obscurus on an Anvil fork, you'll need:

- [The foundry suite](https://book.getfoundry.sh/getting-started/installation)
- [Docker](https://docs.docker.com/engine/install/)

First, run the Anvil fork (for the following steps, it is assumed that the network forked is Holesky):
```shell
anvil -f <YOUR_RPC_URL> --auto-impersonate
```

Anvil starts and provides some pre-funded accounts. We will use the first one for the next steps.

Then, deploy a safe with the default parameters:
```shell
docker run -it safeglobal/safe-cli safe-creator http://host.docker.internal:8545 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

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

Grab the Safe address for the next steps (here `0x43Ca5D81816AA33BfE354438007dCa68224A47AC`).

Next, set those environment variables in your shell. They will be used to create a 2/3 Obscurus Safe:
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

Run the deployment script:
```shell
forge script ./script/Deploy.fork.holesky.s.sol --rpc-url $RPC_URL --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvvv
```

From the `broadcast/Deploy.fork.holesky.s.sol/17000/run-latest.json` file, grab the Obscurus deployment address.
Set the new environment variable in your shell:
```shell
export ODS_OBSCURUS_ADDRESS=0x9c5e1b46cf9d94ec55f8ca6d2075d9dfb988673e
```

This call should confirm that the module has been enabled on the Safe:
```shell
cast call $ODS_SAFE_ADDRESS "isModuleEnabled(address)(bool)" $ODS_OBSCURUS_ADDRESS
# Should return `true`
```

Then, generate the proofs for each one of the Semaphore identity:
```shell
# Identity 0 is Alice.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-alice.json

# Identity 1 is Bob.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "QigfrBOzbDNxo9Y7aJQoY52OSwsdOuEtnFvKFaPaG4g=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-bob.json

# Identity 2 is Pierre.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "h2QBqQRh1ecKCDWzQX1Pt8w2zAK/QwKANcMJA6nQeRs=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-pierre.json
```

Finally, execute the transaction by giving the proofs that will be verified onchain:
```shell
npx tsx test/ts-utils/obscurus-cli.ts exec --proofs /tmp/proof-alice.json /tmp/proof-bob.json /tmp/proof-pierre.json --signer "0xAC0974BEC39A17E36BA4A6B4D238FF944BACB478CBED5EFCAE784D7BF4F2FF80" --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0
```

Nice! You should get an output similar to this:
```shell
{"hash":"0xe6e83eb6d5afa4df26c648b7a370b42d4fc48d5c4a662beeec70e61f23758d0d","result":[true,"0x"]}
```

You can regenerate the proofs, this time only for Alice and Bob, and execute the transaction again. This will work as the number of proofs is still greater than the threshold:
```
# Identity 0 is Alice.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-alice.json

# Identity 1 is Bob.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "QigfrBOzbDNxo9Y7aJQoY52OSwsdOuEtnFvKFaPaG4g=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-bob.json

npx tsx test/ts-utils/obscurus-cli.ts exec --proofs /tmp/proof-alice.json /tmp/proof-bob.json --signer "0xAC0974BEC39A17E36BA4A6B4D238FF944BACB478CBED5EFCAE784D7BF4F2FF80" --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0
```

Again, we got a validation:
```shell
{"hash":"0xb79b94d52aa198be0fba3b9d913611d1dee22402209ce0a8c0f7c9b38def877f","result":[true,"0x"]}
```

But this time, if we try with only Alice, it will fail:
```shell
# Identity 0 is Alice.
npx tsx test/ts-utils/obscurus-cli.ts prove --prover "zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM=" --identities $ODS_IDENTITY_COMMITMENT_0 $ODS_IDENTITY_COMMITMENT_1 $ODS_IDENTITY_COMMITMENT_2 --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0 > /tmp/proof-alice.json

npx tsx test/ts-utils/obscurus-cli.ts exec --proofs /tmp/proof-alice.json --signer "0xAC0974BEC39A17E36BA4A6B4D238FF944BACB478CBED5EFCAE784D7BF4F2FF80" --obscurus-address $ODS_OBSCURUS_ADDRESS --rpc-url $RPC_URL --to "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --value 0 --data 0x --operation 0
```

You should get an error similar to this:
```shell
/Users/Developer/obscurus/test/ts-utils/node_modules/viem/utils/errors/getContractError.ts:78
  return new ContractFunctionExecutionError(cause as BaseError, {
         ^


ContractFunctionExecutionError: The contract function "obscureExecAndReturnData" reverted.

Error: NotEnoughProofs()
```

Another error should occur if you temper the proofs. Going back to the example with 2 identities, Alice and Bob, edit the Alice's proof file before executing the transaction:
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

You should get an error similar to the following one:
```shell
/Users/Developer/obscurus/test/ts-utils/node_modules/viem/utils/errors/getContractError.ts:78
  return new ContractFunctionExecutionError(cause as BaseError, {
         ^


ContractFunctionExecutionError: The contract function "obscureExecAndReturnData" reverted with the following signature:
0x4aa6bc40
```

cast can help us decode the error:
```shell
cast decode-error 0x4aa6bc40
```

Which prints:
```shell
Semaphore__InvalidProof()
```

## Contributing

Coming soon.

## Authors

This project is currently being maintained by the folks at [Quartz Technology](https://github.com/quartz-technology).

