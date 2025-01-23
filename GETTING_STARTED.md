# Getting Started

This section is here to help you deploy and use Obscurus.
Please note that for the moment, the only documented way to deploy the project is on a local network, using Anvil.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Using Anvil Fork](#using-anvil-fork)
    - [1. Fork a network](#1-fork-a-network)
    - [2. Depliy a Safe Wallet](#2-deploy-a-safe-wallet)
    - [3. Deploy Obscurus](#3-deploy-obscurus)
    - [4. Approve a transaction](#4-approve-a-transaction)
    - [5. Execute a transaction](#5-execute-a-transaction)
    - [6. Invalid transactions](#6-invalid-transactions)

## Prerequisites

Before you can deploy and use Obscurus, you must install a few tools:
- [Docker](https://docs.docker.com/engine/install/).
- [Foundry](https://book.getfoundry.sh/getting-started/installation).

Once installed, you can go ahead and follow the steps to deploy and use Obscurus using one of the available methods.

## Using Anvil Fork

Anvil let's you fork a network to deploy and interact with the Obscurus smart contracts.
You will deploy a Safe Wallet owned by a single address, deploy and attach Obscurus to it, owned by 3 identities (Alice, Bob and Charlie) and execute anonymously approved transactions in the Safe Wallet via the Obscurus Module.

Here are the identities public commitments and their respective private keys (used to generate the anonymous approvals).

| Name    | Public Identity Commitment                                                    | Private Key                                  |
|---------|-------------------------------------------------------------------------------|----------------------------------------------|
| Alice   | 16154315983106457604964519632507479861508345150261468393750536759701116467867 | zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM= |
| Bob     | 12241487482047535455927935140249225031445150086629846794755977920490270273737 | QigfrBOzbDNxo9Y7aJQoY52OSwsdOuEtnFvKFaPaG4g= |
| Charlie | 15899159344494353576723282793888645985869881307160044049094584250085609856278 | h2QBqQRh1ecKCDWzQX1Pt8w2zAK/QwKANcMJA6nQeRs= |

For later use, run the following commands in your terminal:
```shell
echo '{"commitment":"16154315983106457604964519632507479861508345150261468393750536759701116467867","privateKey":"zBdAt1wUe6DAK1wEXuJqeSyBiTX+UPA4M95TI3F9mIM="}' > /tmp/alice.json
echo '{"commitment":"12241487482047535455927935140249225031445150086629846794755977920490270273737","privateKey":"QigfrBOzbDNxo9Y7aJQoY52OSwsdOuEtnFvKFaPaG4g="}' > /tmp/bob.json
echo '{"commitment":"15899159344494353576723282793888645985869881307160044049094584250085609856278","privateKey":"h2QBqQRh1ecKCDWzQX1Pt8w2zAK/QwKANcMJA6nQeRs="}' > /tmp/charlie.json
```

### 1. Fork a network

To fork a network, use the following command and replace `<YOUR_RPC_URL>` with a real RPC endpoint.
Here, we will fork Holesky.
```shell
anvil -f <YOUR_RPC_URL> --auto-impersonate
```

### 2. Deploy a Safe Wallet

Using the official Safe CLI tool, you can deploy a Safe using one of the Anvil default account as the owner:
```shell
docker run -it safeglobal/safe-cli safe-creator http://host.docker.internal:8545 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

Here, `0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80` is the private key of one of the default account pre-funded in Anvil.

You should get an output similar to this one:
```

 ____           __          ____                     _
/ ___|   __ _  / _|  ___   / ___| _ __   ___   __ _ | |_   ___   _ __
\___ \  / _` || |_  / _ \ | |    | '__| / _ \ / _` || __| / _ \ | '__|
 ___) || (_| ||  _||  __/ | |___ | |   |  __/| (_| || |_ | (_) || |
|____/  \__,_||_|   \___|  \____||_|    \___| \__,_| \__| \___/ |_|


Network HOLESKY - Sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 - Balance: 10000.000000Ξ
Creating new Safe with owners=['0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'] threshold=1 salt-nonce=80673247063442009942794382047232272872716031358050557285500192846863238031301
Safe-master-copy=0x29fcB43b46531BcA003ddC8FCB67FFE91900C762 version=1.4.1
Fallback-handler=0xfd0732Dc9E303f09fCEf3a7388Ad10A83459Ec99
Proxy factory=0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67
Do you want to continue? [y/N]: y
Safe will be deployed on 0x0721570aceD74667cC8493d83C7d2ceFd094968A, looks good? [y/N]: y
Sent tx with tx-hash=0xc10c475542828c23734e13462dfbb6df9beb1d222015ce4014541538f180ee06 Safe=0x0721570aceD74667cC8493d83C7d2ceFd094968A is being created
Tx parameters={'value': 0, 'gas': 262053, 'maxFeePerGas': 1000000026, 'maxPriorityFeePerGas': 1000000000, 'chainId': 17000, 'from': '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', 'to': '0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67', 'data': '0x1688f0b900000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c7620000000000000000000000000000000000000000000000000000000000000060b25b70920954d360a1a10b5926dac2e846329ad7e310f53b38e5dad72fc9e7c50000000000000000000000000000000000000000000000000000000000000164b63e800d0000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000140000000000000000000000000fd0732dc9e303f09fcef3a7388ad10a83459ec990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'nonce': 1023}
EthereumTxSent(tx_hash=HexBytes('0xc10c475542828c23734e13462dfbb6df9beb1d222015ce4014541538f180ee06'), tx={'value': 0, 'gas': 262053, 'maxFeePerGas': 1000000026, 'maxPriorityFeePerGas': 1000000000, 'chainId': 17000, 'from': '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', 'to': '0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67', 'data': '0x1688f0b900000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c7620000000000000000000000000000000000000000000000000000000000000060b25b70920954d360a1a10b5926dac2e846329ad7e310f53b38e5dad72fc9e7c50000000000000000000000000000000000000000000000000000000000000164b63e800d0000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000140000000000000000000000000fd0732dc9e303f09fcef3a7388ad10a83459ec990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'nonce': 1023}, contract_address='0x0721570aceD74667cC8493d83C7d2ceFd094968A')
```

Copy and save the Safe Wallet address. In the example above, it is `0x0721570aceD74667cC8493d83C7d2ceFd094968A`.

### 3. Deploy Obscurus

It is now time to deploy the Obscurus Module and attach it to the Safe Wallet you just deployed.
In your terminal, set the following environment variables:
```shell
export RPC_URL=http://localhost:8545
export ODS_SAFE_OWNER_PK=77814517325470205911140941194401928579557062014761831930645393041380819009408
export ODS_SAFE_ADDRESS=0x0721570aceD74667cC8493d83C7d2ceFd094968A
export ODS_OBSCURUS_THRESHOLD=2
export ODS_OBSCURUS_NUM_IDENTITIES=3
export ODS_OBSCURUS_IDENTITY_0=16154315983106457604964519632507479861508345150261468393750536759701116467867
export ODS_OBSCURUS_IDENTITY_1=12241487482047535455927935140249225031445150086629846794755977920490270273737
export ODS_OBSCURUS_IDENTITY_2=15899159344494353576723282793888645985869881307160044049094584250085609856278
```

Here, the threshold required to execute a transaction is 2, so you will need to provide 2 out of 3 anonymous approvals minimum so that the transaction can be executed.

Now run the following command to deploy the module and attach it to the Safe Wallet:
```shell
forge script ./script/local/Deploy.local.s.sol --rpc-url $RPC_URL --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

If something went wrong at this step, try removing the `broadcast` and `cache` folders.
Otherwise, you should get a `cat broadcast/Deploy.local.s.sol/17000/run-latest.json` file which contains the Obscurus deployment address.

Copy it and set a new environment variable in your terminal:
```shell
export ODS_OBSCURUS_ADDRESS=0xbdf04ab3c4283b1531b8cf812ef21d4fed9be445
```

You can confirm that the Obscurus module has been enabled (attached) to the Safe by running the following command, which should print `true`:
```shell
cast call $ODS_SAFE_ADDRESS "isModuleEnabled(address)(bool)" $ODS_OBSCURUS_ADDRESS
```

### 4. Approve a transaction

Before executing a transaction, it must be approved.
In the context of Obscurus, this means that at least K identities (with K being the threshold we defined earlier) must generate proofs.

You can think of those proofs as some kind of commitments over which transaction is approved.
They also prevent double-approval by a unique identity and guarantee membership, so the proof will be invalid if one identity submits two proofs for the same transaction approval or if an identity external to the group submits a proof.

To generate the proofs, run the following commands. Here, the transaction is very simple: it has no calldata, and transfers 0 ETH.
In a real world scenario, the group members generates a proof on their own and they all could send it to a trusted Relay for example.
```shell
# Identity 0 is Alice.
npx tsx tools/obscurus-cli/index.ts gen-remote-proof --prover-key-file /tmp/alice.json --identities $ODS_OBSCURUS_IDENTITY_0 $ODS_OBSCURUS_IDENTITY_1 $ODS_OBSCURUS_IDENTITY_2 --contract-address $ODS_OBSCURUS_ADDRESS --to "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" --value 0 --data 0x --operation 0 --file /tmp/alice_proof.json

# Identity 1 is Bob.
npx tsx tools/obscurus-cli/index.ts gen-remote-proof --prover-key-file /tmp/bob.json --identities $ODS_OBSCURUS_IDENTITY_0 $ODS_OBSCURUS_IDENTITY_1 $ODS_OBSCURUS_IDENTITY_2 --contract-address $ODS_OBSCURUS_ADDRESS --to "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" --value 0 --data 0x --operation 0 --file /tmp/bob_proof.json
```

### 5. Execute a transaction

Now that the proofs used to approve the transaction have been generated by the identities, you can execute it using the following command.
This will verify the proofs onchain and require that at least the threshold is respected.

Here the proofs files are named for simplicity but they obviously should not leak the identity of their creators.
Also, note that the address sending the transaction (`--signer`) is someone else. In fact, tt could be anyone sending the proofs on the behalf of the identity!
```shell
npx tsx tools/obscurus-cli/index.ts obscure-exec --tx-signer 0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e --proof-files /tmp/alice_proof.json /tmp/bob_proof.json --contract-address $ODS_OBSCURUS_ADDRESS --to 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --value 0 --data "0x" --operation 0
```

Which should print something similar to this:
```shell
[ true, '0x' ]
```

Well done! The Safe Wallet has executed a transaction which has been proved by the Obscurus Module and does not leak the identity of the members that have approved it in the first place!
In a real world scenario, nothing can link the proofs to their creator and therefore nobody will be able to know who has approved (or restrained from approving) a transaction.

#### 6. Invalid transactions

You can also generate only one proof and try to execute the transaction, it will not work at the threshold is not met:
```shell
# Identity 0 is Alice.
npx tsx tools/obscurus-cli/index.ts gen-remote-proof --prover-key-file /tmp/alice.json --identities $ODS_OBSCURUS_IDENTITY_0 $ODS_OBSCURUS_IDENTITY_1 $ODS_OBSCURUS_IDENTITY_2 --contract-address $ODS_OBSCURUS_ADDRESS --to "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" --value 0 --data 0x --operation 0 --file /tmp/alice_proof_2.json

npx tsx tools/obscurus-cli/index.ts obscure-exec --tx-signer 0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e --proof-files /tmp/alice_proof_2.json --contract-address $ODS_OBSCURUS_ADDRESS --to 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --value 0 --data "0x" --operation 0
```

You should get the following error:
```shell
  return new ContractFunctionExecutionError(cause as BaseError, {
         ^
ContractFunctionExecutionError: The contract function "obscureExecAndReturnData" reverted.

Error: InvalidExecutionNotEnoughProofs()
```

Or, you can also try to temper with one of the generated proof.
Lets try to approve a transaction with 2 entities and corrupt one of them:
```shell
# Identity 0 is Alice.
npx tsx tools/obscurus-cli/index.ts gen-remote-proof --prover-key-file /tmp/alice.json --identities $ODS_OBSCURUS_IDENTITY_0 $ODS_OBSCURUS_IDENTITY_1 $ODS_OBSCURUS_IDENTITY_2 --contract-address $ODS_OBSCURUS_ADDRESS --to "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" --value 0 --data 0x --operation 0 --file /tmp/alice_proof_3.json

# Identity 1 is Bob.
npx tsx tools/obscurus-cli/index.ts gen-remote-proof --prover-key-file /tmp/bob.json --identities $ODS_OBSCURUS_IDENTITY_0 $ODS_OBSCURUS_IDENTITY_1 $ODS_OBSCURUS_IDENTITY_2 --contract-address $ODS_OBSCURUS_ADDRESS --to "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" --value 0 --data 0x --operation 0 --file /tmp/bob_proof_3.json

##
## Before running the command below, edit the /tmp/alice_proof_3.json file.
## Try replacing one of the nullifier field for example.
##

npx tsx tools/obscurus-cli/index.ts obscure-exec --tx-signer 0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e --proof-files /tmp/alice_proof_3.json /tmp/bob_proof_3.json --contract-address $ODS_OBSCURUS_ADDRESS --to 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --value 0 --data "0x" --operation 0
```

This will result in the following error:
```shell
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
