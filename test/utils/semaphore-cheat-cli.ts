import { Identity } from "@semaphore-protocol/core";
import { Group } from "@semaphore-protocol/group";
import { Command } from "commander";
import { generateProof } from "@semaphore-protocol/proof";
import { stringToBytes } from "viem";

const program = new Command();

program
  .version("0.0.1")
  .description("CLI Tool used to perform various semaphore actions.");

program
  .command("generate-identity")
  .option("-s, --secret <secret>", "Secret value used to generate the identity.")
  .action((options) => {
    generateCheatIdentity(options.secret);
  });

program
  .command("generate-group")
  .option("-i, --identities <identities...>", "Identities to include in the group.")
  .action((options) => {
    generateCheatGroup(options.identities);
  });

program
  .command("generate-proof")
  .option("-p, --prover <private-key>", "Prover identity private key.")
  .option("-i, --identities <identities...>", "Identities to include in the group.")
  .option("-m, --message <message>", "Message to prove.")
  .option("-s, --scope <scope>", "Scope used to prevent double signaling.")
  .action(async (options) => {
    await generateCheatProof(options.prover, options.identities, options.message, options.scope);

    process.exit(0);
  });

(async () => {
  await program.parseAsync();
})();

function generateCheatIdentity(secret?: string) {
  let identity: Identity;

  if (secret) {
    identity = new Identity(secret);
  } else {
    identity = new Identity();
  }

  console.log(JSON.stringify({
    commitment: identity.commitment.toString(),
    privateKey: identity.export()
  }));
}

function generateCheatGroup(identities: string[]) {
  const group = new Group(identities);

  console.log(JSON.stringify({
    root: group.root.toString(),
  }));
}

async function generateCheatProof(prover: string, identities: string[], message: string, scope: string) {
  const identity = Identity.import(prover);

  const group = new Group(identities);
  const encodedMessage = stringToBytes(message, { size: 32 });

  const proof = await generateProof(identity, group, encodedMessage, scope);
  console.log(JSON.stringify({
    ...proof,
  }));

}

