import { Command } from "commander";
import { Address, createPublicClient, createWalletClient, getContract, GetContractReturnType, http, publicActions, PublicClient } from "viem";
import { privateKeyToAccount } from 'viem/accounts'
import { OBSCURUS_ABI } from "./obscurus.abi";
import { generateProof, Group, Identity } from "@semaphore-protocol/core";
import * as fs from 'fs';

const program = new Command();

program
  .version("0.0.1")
  .description("CLI tool to interact with the Obscurus contract.")

program
  .command("prove")
  .requiredOption("-p, --prover <private-key>", "Prover identity private key.")
  .requiredOption("-i, --identities <identities...>", "Identities to include in the group.")
  .requiredOption("--to <to>", "TODO.")
  .requiredOption("--value <value>", "TODO.")
  .requiredOption("--data <data>", "TODO.")
  .requiredOption("--operation <operation>", "TODO.")
  .action(async (option) => {
    const contract = obscurusGetContract(option.rpcUrl, option.obscurusAddress);
    const proof = await obscurusGenerateProof(
      contract,
      option.prover,
      option.identities,
      option.to,
      BigInt(option.value),
      option.data,
      Number(option.operation),
    );

    console.log(JSON.stringify({
      proof: proof,
    }));

    process.exit(0);
  });


program
  .command("exec")
  .requiredOption("--signer <signer>", "TODO.")
  .requiredOption("--proofs <proofs...>", "TODO.")
  .requiredOption("--to <to>", "TODO.")
  .requiredOption("--value <value>", "TODO.")
  .requiredOption("--data <data>", "TODO.")
  .requiredOption("--operation <operation>", "TODO.")
  .action(async (option) => {
    const account = privateKeyToAccount(option.signer);

    const client = createWalletClient({
      account,
      transport: http(option.rpcUrl),
    }).extend(publicActions)

    const proofs = [];

    for (const proofFile of option.proofs) {
      const proof = JSON.parse(fs.readFileSync(proofFile, 'utf8'));

      proofs.push(proof);
    }

    const contract = getContract({
      address: option.obscurusAddress,
      abi: OBSCURUS_ABI,
      client: client,
    })

    const { request, result } = await client.simulateContract({
      address: option.obscurusAddress,
      abi: OBSCURUS_ABI,
      functionName: "obscureExecAndReturnData",
      args: [
        option.to,
        BigInt(option.value),
        option.data,
        Number(option.operation),
        proofs.map(({ proof }) => {
          return {
            merkleTreeDepth: BigInt(proof.merkleTreeDepth),
            merkleTreeRoot: BigInt(proof.merkleTreeRoot),
            nullifier: BigInt(proof.nullifier),
            message: BigInt(proof.message),
            scope: BigInt(proof.scope),
            points: proof.points.map((point: bigint) => BigInt(point)),
          }
        }),
      ],
      account,
    });

    const hash = await client.writeContract(request);
    await client.waitForTransactionReceipt({ hash });

    console.log(JSON.stringify({
      hash: hash,
      result: result,
    }));

    process.exit(0);
  });

program.commands.forEach(command => {
  command.requiredOption("--rpc-url <rpc-url>", "URL of the RPC server.");
  command.requiredOption("--obscurus-address <obscurus-address>", "Address of the Obscurus contract.");
});

(async () => {
  await program.parseAsync();
})();

function obscurusGetContract(rpcUrl: string, obscurusAddress: Address): GetContractReturnType<typeof OBSCURUS_ABI, PublicClient> {
  const client = createPublicClient({
    transport: http(rpcUrl),
  })

  return getContract({
    address: obscurusAddress,
    abi: OBSCURUS_ABI,
    client: client,
  })

}

async function obscurusGenerateProof(
  contract: GetContractReturnType<typeof OBSCURUS_ABI, PublicClient>,
  prover: string,
  identities: string[],
  to: Address,
  value: bigint,
  data: `0x${string}`,
  operation: number,
) {
  const signal = await contract.read.computeSignal();
  const scope = await contract.read.computeScope([
    to,
    value,
    data,
    operation,
  ]);

  const identity = Identity.import(prover);

  const group = new Group(identities);
  const encodedMessage = BigInt(signal);

  const proof = await generateProof(identity, group, encodedMessage, scope);

  return proof;
}

