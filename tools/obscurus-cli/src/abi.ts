export const ABI = [
  {
    "type": "constructor",
    "inputs": [
      {
        "name": "params",
        "type": "tuple",
        "internalType": "struct IObscurus.InitParameters",
        "components": [
          {
            "name": "safe",
            "type": "address",
            "internalType": "address"
          },
          {
            "name": "semaphore",
            "type": "address",
            "internalType": "address"
          },
          {
            "name": "identities",
            "type": "uint256[]",
            "internalType": "uint256[]"
          },
          {
            "name": "threshold",
            "type": "uint256",
            "internalType": "uint256"
          }
        ]
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "addMember",
    "inputs": [
      {
        "name": "_newMemberIdentityCommitment",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "addMembers",
    "inputs": [
      {
        "name": "_newMembersIdentityCommitments",
        "type": "uint256[]",
        "internalType": "uint256[]"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "avatar",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "computeScope",
    "inputs": [
      {
        "name": "params",
        "type": "tuple",
        "internalType": "struct IObscurus.TxParameters",
        "components": [
          {
            "name": "to",
            "type": "address",
            "internalType": "address"
          },
          {
            "name": "value",
            "type": "uint256",
            "internalType": "uint256"
          },
          {
            "name": "data",
            "type": "bytes",
            "internalType": "bytes"
          },
          {
            "name": "operation",
            "type": "uint8",
            "internalType": "enum Enum.Operation"
          }
        ]
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "computeSignal",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "groupID",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "nonce",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "numIdentities",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "obscureExec",
    "inputs": [
      {
        "name": "params",
        "type": "tuple",
        "internalType": "struct IObscurus.ObscureExecParameters",
        "components": [
          {
            "name": "txParameters",
            "type": "tuple",
            "internalType": "struct IObscurus.TxParameters",
            "components": [
              {
                "name": "to",
                "type": "address",
                "internalType": "address"
              },
              {
                "name": "value",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "data",
                "type": "bytes",
                "internalType": "bytes"
              },
              {
                "name": "operation",
                "type": "uint8",
                "internalType": "enum Enum.Operation"
              }
            ]
          },
          {
            "name": "semaphoreProofs",
            "type": "tuple[]",
            "internalType": "struct ISemaphore.SemaphoreProof[]",
            "components": [
              {
                "name": "merkleTreeDepth",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "merkleTreeRoot",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "nullifier",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "message",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "scope",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "points",
                "type": "uint256[8]",
                "internalType": "uint256[8]"
              }
            ]
          }
        ]
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "bool",
        "internalType": "bool"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "obscureExecAndReturnData",
    "inputs": [
      {
        "name": "params",
        "type": "tuple",
        "internalType": "struct IObscurus.ObscureExecParameters",
        "components": [
          {
            "name": "txParameters",
            "type": "tuple",
            "internalType": "struct IObscurus.TxParameters",
            "components": [
              {
                "name": "to",
                "type": "address",
                "internalType": "address"
              },
              {
                "name": "value",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "data",
                "type": "bytes",
                "internalType": "bytes"
              },
              {
                "name": "operation",
                "type": "uint8",
                "internalType": "enum Enum.Operation"
              }
            ]
          },
          {
            "name": "semaphoreProofs",
            "type": "tuple[]",
            "internalType": "struct ISemaphore.SemaphoreProof[]",
            "components": [
              {
                "name": "merkleTreeDepth",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "merkleTreeRoot",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "nullifier",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "message",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "scope",
                "type": "uint256",
                "internalType": "uint256"
              },
              {
                "name": "points",
                "type": "uint256[8]",
                "internalType": "uint256[8]"
              }
            ]
          }
        ]
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "bool",
        "internalType": "bool"
      },
      {
        "name": "",
        "type": "bytes",
        "internalType": "bytes"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "owner",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "renounceOwnership",
    "inputs": [],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "semaphore",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "contract ISemaphore"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "setAvatar",
    "inputs": [
      {
        "name": "_avatar",
        "type": "address",
        "internalType": "address"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "setTarget",
    "inputs": [
      {
        "name": "_target",
        "type": "address",
        "internalType": "address"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "setThreshold",
    "inputs": [
      {
        "name": "_newThreshold",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "setUp",
    "inputs": [
      {
        "name": "initializeParams",
        "type": "bytes",
        "internalType": "bytes"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "target",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "threshold",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "transferOwnership",
    "inputs": [
      {
        "name": "newOwner",
        "type": "address",
        "internalType": "address"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "event",
    "name": "AvatarSet",
    "inputs": [
      {
        "name": "previousAvatar",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      },
      {
        "name": "newAvatar",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "Initialized",
    "inputs": [
      {
        "name": "version",
        "type": "uint64",
        "indexed": false,
        "internalType": "uint64"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "MemberAdded",
    "inputs": [
      {
        "name": "newMemberIdentityCommitment",
        "type": "uint256",
        "indexed": false,
        "internalType": "uint256"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "MembersAdded",
    "inputs": [
      {
        "name": "newMembersIdentityCommitments",
        "type": "uint256[]",
        "indexed": false,
        "internalType": "uint256[]"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "ObscureTransactionExecuted",
    "inputs": [
      {
        "name": "success",
        "type": "bool",
        "indexed": false,
        "internalType": "bool"
      },
      {
        "name": "scope",
        "type": "uint256",
        "indexed": false,
        "internalType": "uint256"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "OwnershipTransferred",
    "inputs": [
      {
        "name": "previousOwner",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      },
      {
        "name": "newOwner",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "TargetSet",
    "inputs": [
      {
        "name": "previousTarget",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      },
      {
        "name": "newTarget",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "ThresholdSet",
    "inputs": [
      {
        "name": "newThreshold",
        "type": "uint256",
        "indexed": false,
        "internalType": "uint256"
      }
    ],
    "anonymous": false
  },
  {
    "type": "error",
    "name": "InvalidExecutionNotEnoughProofs",
    "inputs": []
  },
  {
    "type": "error",
    "name": "InvalidExecutionScope",
    "inputs": []
  },
  {
    "type": "error",
    "name": "InvalidExecutionSignal",
    "inputs": []
  },
  {
    "type": "error",
    "name": "InvalidInitialization",
    "inputs": []
  },
  {
    "type": "error",
    "name": "InvalidThresholdTooHigh",
    "inputs": []
  },
  {
    "type": "error",
    "name": "InvalidThresholdZero",
    "inputs": []
  },
  {
    "type": "error",
    "name": "NotInitializing",
    "inputs": []
  },
  {
    "type": "error",
    "name": "OwnableInvalidOwner",
    "inputs": [
      {
        "name": "owner",
        "type": "address",
        "internalType": "address"
      }
    ]
  },
  {
    "type": "error",
    "name": "OwnableUnauthorizedAccount",
    "inputs": [
      {
        "name": "account",
        "type": "address",
        "internalType": "address"
      }
    ]
  }
] as const;
