import * as fs from 'fs';
import { Group } from "@semaphore-protocol/group";
import { Identity } from "@semaphore-protocol/identity";
import { generateProof, SemaphoreProof } from "@semaphore-protocol/proof";

export async function genProof(prover: string, identities: string[], message: bigint, scope: bigint): Promise<SemaphoreProof> {
  const identity = Identity.import(prover);
  const group = new Group(identities);

  return await generateProof(identity, group, message, scope);
}

export function encodeProofToJSON(proof: SemaphoreProof): string {
  return JSON.stringify({
    ...proof,
  });
}

export function decodeProofFromJSON(data: string): SemaphoreProof {
  const proof = JSON.parse(data);
  const res: SemaphoreProof = {
    merkleTreeDepth: Number(proof.merkleTreeDepth),
    merkleTreeRoot: (proof.merkleTreeRoot),
    nullifier: (proof.nullifier),
    message: (proof.message),
    scope: (proof.scope),
    points: proof.points.map((point: string) => BigInt(point)),
  };

  return res;
}

export function convertSemaphoreProofToABI(proof: SemaphoreProof) {
  return {
    merkleTreeDepth: BigInt(proof.merkleTreeDepth),
    merkleTreeRoot: BigInt(proof.merkleTreeRoot),
    nullifier: BigInt(proof.nullifier),
    message: BigInt(proof.message),
    scope: BigInt(proof.scope),
    points: [
      BigInt(proof.points[0]),
      BigInt(proof.points[1]),
      BigInt(proof.points[2]),
      BigInt(proof.points[3]),
      BigInt(proof.points[4]),
      BigInt(proof.points[5]),
      BigInt(proof.points[6]),
      BigInt(proof.points[7]),
    ],
  } as {
    merkleTreeDepth: bigint;
    merkleTreeRoot: bigint;
    nullifier: bigint;
    message: bigint;
    scope: bigint;
    points: readonly [bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint];
  };
}

export function storeProof(proof: SemaphoreProof, file: string) {
  fs.writeFileSync(file, encodeProofToJSON(proof));
}

export function printProof(proof: SemaphoreProof) {
  console.log(encodeProofToJSON(proof));
}
