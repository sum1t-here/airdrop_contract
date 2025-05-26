# 🌿 Merkle Airdrop

A secure, gas-efficient smart contract system to distribute ERC-20 tokens using Merkle Tree proofs and ECDSA signatures. Built with Foundry, this system ensures that only eligible users can claim their tokens exactly once.

## 📌 Features

- ✅ Merkle Proof-based eligibility
- 🔐 ECDSA Signature-based claim validation
- 🚫 One-time claim enforcement per wallet
- 📦 Foundry DevOpsTools integration
- 🧪 Includes claim interaction script

## 📁 Project Structure
```
.github/
  workflows/
    test.yml
lib/
  forge-std
  foundry-devops
  murky
  openzeppelin-contracts
script/
  target/
    input.json
    output.json
  DeployAirdrop.s.sol
  GenerateInput.s.sol
  Interact.s.sol
  MakeMerkle.s.sol
src/
  Airdrop.sol
  AirdropToken.sol
test/
  Airdrop.t.sol
.gitignore
.gitmodules
foundry.toml
Makefile
README.md
```

---

## ⚙️ Requirements

- [Foundry](https://book.getfoundry.sh/)
- Anvil (optional, for local testing)

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/sum1t-here/airdrop_contract

cd airdrop_contract
```

### 2. Install Dependencies
```bash
forge install
```

### 3. Compile Contracts
```bash
forge build
```

## 🧾 How the Claim Works
Users must provide:

- Their address

- The airdrop amount

- A valid Merkle proof

- A signed message (ECDSA signature) from the deployer or trusted backend

## 👨‍💻 Author
Sumit Mazumdar

Blockchain Developer

GitHub: [@sum1t-here](https://github.com/sum1t-here)

X: [@sum1t_here](https://x.com/sum1t_here)
