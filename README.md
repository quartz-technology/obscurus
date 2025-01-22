# <h1 align="center"> Obscurus </h1>

<p align="center">
    <img src=".github/assets/README_ILLUSTRATION.png" style="border-radius:5%" width="800" alt="">
</p>

<p align="center">
    Privacy layer for Safe Wallet owners, built using Semaphore and Zodiac.
</p>

## Table of Contents

- [Disclaimer](#disclaimer)
- [Acknowledgements](#acknowledgments)
- [Introduction](#introduction)
- [Architecture](#architecture)
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

## Acknowledgements

We wanted to thank the following entities / persons for their precious help. This project would not exist without their contributions and solutions:

- [Safe](https://safe.global/). This project relies on the Safe Wallet, so it is obvious that they deserve a praise.
- [Zodiac](https://zodiac.wiki/). Extra-logic on Safe Wallets can only be achieved via Zodiac Modules.
- [Colin Nielsen](https://github.com/colinnielsen). We used [safe-tools](https://github.com/colinnielsen/safe-tools) to test Obscurus, and its design is partially inspired by [dark-safe](https://github.com/colinnielsen/dark-safe). Go ahead and take a look at Colin's projects, they're amazing.
- [PSE](https://pse.dev/). Obscurus would have been much more difficult to develop if it was not without Semaphore, the framework built by the PSE team.

## Introduction

As a reminder, a multi-signature wallet such as Safe Wallet is a smart contract that requires multiple approvals (or "signatures") to complete a transaction.
For example, when creating a 2/3 Safe, 3 different owners will control the multisig and all the transactions it will execute first need to be approved by at least 2 out of the 3 owners (with 2 being referred to as the "threshold").

Although this provides an amazing security solution to manage assets and perform operations, the mechanism that verifies the approvals leaks the identity of the owners who emitted those: everyone is able to know which ones of the owners approved an operation and by deduction which ones have not.

This is where Obscurus comes into play. It provides a privacy layer on top of Safe in the form of a Zodiac Module - additional logic that can be attached to Safe Wallets and able to bypass the default signatures verification mechanism.

It guarantees the following:
- A set of owners (or "identities") control the Obscurus Module.
- Identities can submit anonymous approvals for operation to be executed by the Safe this Module is attached to.
- A number of anonymous approvals (the "threshold") still needs to be reached prior to execute the operation.
- It is impossible to identify which identity submitted which approval (the "anonymous" property).
- The identities submitting the anonymous approvals are part of the group controlling the Module (as opposed to external - "unauthorized" - identities).

## Architecture

Coming soon.

## Getting Started

Coming soon.

## Contributing

Coming soon.

## Authors

This project is currently being maintained by the folks at [Quartz Technology](https://github.com/quartz-technology).

