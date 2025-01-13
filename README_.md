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
When transactions are approved, nobody can know which one of the identities made the approval, but with the following guarantees
- It is indeed a member of this group.
- A single identity cannot approve a given transaction more than once.

### Goal

The goal of Obscurus is to provide anonymity to the Safe Wallet owners, while retaining the mechanisms of the multi-signature wallet.

### Details

Usually in a Safe Wallet, K over M (with K <= M) owners are required to approve and execute a transaction from the multisig.
Zodiac Modules contain additional logic that can be plugged-in to a Safe Wallet which have the interesting property of being able to bypass the traditional flow of execution.
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

## Contributing

Coming soon.

## Authors

This project is currently being maintained by the folks at [Quartz Technology](https://github.com/quartz-technology).

