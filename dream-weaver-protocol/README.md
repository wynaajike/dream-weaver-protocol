# 🌙 Dream Weaver Protocol

> *Transform consciousness into currency. Trade dreams, mine the collective unconscious, and weave new realities.*

[![Stacks](https://img.shields.io/badge/Stacks-2.0-purple.svg)](https://www.stacks.co/)
[![Clarity](https://img.shields.io/badge/Clarity-Smart%20Contract-blue.svg)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎭 Overview

Dream Weaver Protocol is a revolutionary decentralized lucid dream marketplace built on the Stacks blockchain. It creates an economy where dreams become tradeable experiences, sleep generates value, and the collective unconscious becomes a mineable resource.

### Key Features

- 💤 **REM Mining**: Generate tokens through sleep cycles
- 🎨 **Dream Capture**: Transform dreams into NFT-like tradeable assets
- 🕸️ **Dream Weaving**: Combine multiple dreams to create new realities
- 👹 **Nightmare Battles**: Conquer fears collectively for rewards
- 🌌 **Astral Infrastructure**: Build portals between dream realms
- 📈 **Dream Marketplace**: Trade experiences with other dreamers

## 🚀 Quick Start

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity smart contract development tool
- [Stacks Wallet](https://www.hiro.so/wallet) - For interacting with the protocol

### Installation

```bash
# Clone the repository
git clone https://github.com/wynaajike/dream-weaver-protocol
cd dream-weaver-protocol

# Install dependencies
clarinet install

# Run tests
clarinet test

# Check contract
clarinet check
```

### Deployment

```bash
# Deploy to testnet
clarinet deploy --testnet

# Deploy to mainnet
clarinet deploy --mainnet
```

## 🎯 Core Concepts

### 1. Dreamer Profiles

Every user must initialize as a dreamer to participate:

```clarity
(contract-call? .dream-weaver-protocol enter-dreamscape "YourDreamName")
```

**Profile includes:**
- Lucidity Level (0-100)
- REM Tokens balance
- Astral Rank progression
- Reality Anchors
- Dream statistics

### 2. Sleep Cycles & REM Mining

Generate REM tokens by entering sleep cycles:

```clarity
;; Enter a sleep cycle for 8 hours (480 minutes)
(contract-call? .dream-weaver-protocol enter-sleep-cycle u480)
```

**Mining Formula:**
- Base REM = (sleep-duration × conversion-rate) / 1000
- Bonus = lucidity-level multiplier
- Max 1000 REM per cycle

### 3. Dream Types

- **Lucid**: Conscious control, increases reality stability
- **Prophetic**: Rare spontaneous dreams with special properties
- **Nightmare**: Challenging dreams that decrease stability
- **Astral**: Deep unconscious exploration
- **Shared**: Collaborative dream experiences

### 4. Dream Properties

Each captured dream has:
- **Vividness** (1-100): Visual clarity
- **Coherence** (1-100): Logical consistency
- **Symbol Density**: Meaning richness
- **Reality Bleed**: Effect on waking world
- **Emotion Palette**: Up to 5 emotional tags

### 5. Reality Stability

Global metric affected by all dream activity:
- Nightmares decrease stability (-5)
- Lucid dreams increase stability (+2)
- Portal creation drains stability
- Must be >30 to safely sleep

## 💡 Usage Examples

### Basic Dream Capture

```clarity
;; First, enter sleep
(contract-call? .dream-weaver-protocol enter-sleep-cycle u300)

;; Capture a lucid dream
(contract-call? .dream-weaver-protocol capture-dream 
  "lucid"
  (list "joy" "wonder" "peace")
  u85  ;; vividness
  u90  ;; coherence
  0x1234...  ;; dream hash
)

;; Wake up before next cycle
(contract-call? .dream-weaver-protocol wake-up)
```

### Trading Dreams

```clarity
;; List dream for sale
(contract-call? .dream-weaver-protocol list-dream-for-sale 
  u1      ;; dream-id
  u500    ;; price
  "rem"   ;; currency (rem or stx)
  true    ;; preview available
)

;; Purchase a dream
(contract-call? .dream-weaver-protocol purchase-dream u1)
```

### Dream Weaving

```clarity
;; Combine multiple dreams
(contract-call? .dream-weaver-protocol weave-dreams
  (list u1 u2 u3)  ;; component dream IDs
  "constellation"   ;; weave pattern
)
```

### Nightmare Confrontation

```clarity
;; Face a nightmare with REM tokens
(contract-call? .dream-weaver-protocol confront-nightmare
  u1     ;; nightmare-id
  u100   ;; REM tokens to commit
)
```

## 🏗️ Architecture

### Smart Contract Structure

```
dream-weaver-protocol/
├── contracts/
│   └── dream-weaver-protocol.clar
├── tests/
│   └── dream-weaver-protocol_test.ts
├── settings/
│   └── Devnet.toml
└── Clarinet.toml
```

### Key Data Maps

- `dreamers`: User profiles and statistics
- `dream-experiences`: Captured dream NFTs
- `dream-weaves`: Combined dream creations
- `nightmares`: Collective challenges
- `dream-portals`: Inter-realm gateways
- `dream-market`: Active marketplace listings

### Economic Model

1. **Generation**: REM tokens through sleep
2. **Consumption**: Capturing dreams costs REM
3. **Trading**: Dreams can be sold for REM or STX
4. **Staking**: Commit REM to battle nightmares
5. **Rewards**: Earn from spontaneous dreams and conquests

## 🎮 Advanced Features

### Spontaneous Dreams

10% chance during sleep cycles to capture rare dreams:

```clarity
(contract-call? .dream-weaver-protocol capture-spontaneous-dream)
```

### Portal Creation

High-level dreamers can create travel portals:

```clarity
(contract-call? .dream-weaver-protocol open-dream-portal
  "nightmare-realm"
  "astral-plane"
  u50  ;; toll in REM
)
```

### Astral Ranks

Progress through ranks by actions:
1. **Sleeper**: Starting rank
2. **Lucid**: Basic dream control
3. **Architect**: Can create portals
4. **Void-Walker**: Master of all realms

## 📊 Protocol Statistics

Query global metrics:

```clarity
(contract-call? .dream-weaver-protocol get-dreamscape-stats)
```

Returns:
- Total dreams captured
- Active dream weaves
- Portal network size
- Collective unconscious depth
- Reality stability percentage

## 🛡️ Security Considerations

1. **Sleep Cooldown**: 144 blocks (~24 hours) between cycles
2. **Reality Checks**: Cannot sleep if reality stability <30
3. **Dream Validation**: Properties must be within valid ranges
4. **Anti-Spam**: Costs associated with all major actions

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md).

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📚 Resources

- [Clarity Documentation](https://docs.stacks.co/clarity)
- [Stacks Developer Portal](https://docs.stacks.co)
- [Dream Weaver Whitepaper](docs/whitepaper.pdf)
- [Community Discord](https://discord.gg/dreamweaver)

## 🎯 Roadmap

### Phase 1: Foundation ✅
- Core dream capture mechanics
- REM token generation
- Basic marketplace

### Phase 2: Expansion 🚧
- Multiplayer dream weaving
- Guild system
- Advanced nightmare raids

### Phase 3: Metaverse
- Cross-chain dream bridges
- VR integration
- AI dream generation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Stacks Foundation for blockchain infrastructure
- Carl Jung for collective unconscious theory
- The lucid dreaming community for inspiration

---

*"In dreams, we enter a world that's entirely our own. Let them swim in the deepest ocean or glide over the highest cloud."* - Albus Dumbledore

**Dream responsibly. Trade wisely. Wake refreshed.**

Built with 💤 by the Dream Weaver Team