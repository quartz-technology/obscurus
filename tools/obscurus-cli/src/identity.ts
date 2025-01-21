import { Identity } from '@semaphore-protocol/identity';
import * as fs from 'fs';

export function genIdentity(secret?: string): Identity {
  let identity: Identity;

  if (secret) {
    identity = new Identity(secret);
  } else {
    identity = new Identity();
  }

  return identity;
}

export function encodeIdentityToJSON(identity: Identity): string {
  return JSON.stringify({
    commitment: identity.commitment.toString(),
    privateKey: identity.export(),
  });
}

export function storeIdentity(identity: Identity, file: string) {
  fs.writeFileSync(file, encodeIdentityToJSON(identity));
}

export function printIdentity(identity: Identity) {
  console.log(encodeIdentityToJSON(identity));
}

