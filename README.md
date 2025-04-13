# zkTune Music Streaming Platform

A decentralized music streaming platform on zkSync that leverages native account transaction abstraction and paymaster functionality. zkTune allows artists to mint their songs as NFTs and lets users stream them seamlessly, using secure and standardized smart contracts built with Solidity and OpenZeppelin.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Smart Contracts](#smart-contracts)
  - [SongNFT](#songnft)
  - [zkTune](#zktune)
- [Prerequisites](#prerequisites)
- [Installation and Setup](#installation-and-setup)
- [Deployment](#deployment)
- [Testing](#testing)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

---

## Overview

zkTune is a decentralized dApp designed for music streaming on the zkSync network. It allows artists to mint songs as NFTs and provides users a pay-per-stream model leveraging zkSync’s native account transaction abstraction. The project builds on robust smart contract standards from OpenZeppelin, ensuring security and upgradeability.

---

## Features

- **Decentralized Music Streaming:** Artists mint their musical works as NFTs; users stream directly via the blockchain.
- **NFT Minting:** Utilize the [SongNFT](#songnft) contract to mint unique song tokens with associated metadata (audio and cover image URIs).
- **Royalty Management:** Automatic calculation and collection of royalties via paymaster integration.
- **User & Artist Profiles:** Register as an artist or a user on the platform.
- **Streaming Analytics:** Track stream counts per song and maintain user and artist history.
- **zkSync Integration:** Leverage zkSync’s account abstraction and paymaster for low-cost, efficient transactions.
- **Security and Standardization:** Built using Solidity, OpenZeppelin contracts, and industry best practices.

---

## Architecture

zkTune is built upon a modular and scalable design:

1. **Smart Contracts:**  
   - **SongNFT Contract:** Handles NFT creation, metadata storage, and royalty distribution.
   - **zkTune Contract:** Manages artist/user registrations, song management, and stream tracking.
2. **Deployment Scripts:**  
   - Utilizes a deployment script to deploy the GeneralPaymaster alongside zkTune.
3. **zkSync Network:**  
   - Leverages zkSync's native account abstraction for gas efficiency and enhanced user experience.
4. **OpenZeppelin Libraries:**  
   - Standardized implementations for ERC721, Ownable, and SafeMath to enforce reliability and security.

---

## Smart Contracts

### SongNFT

The `SongNFT` contract extends the ERC721 standard with URI storage and ownership features. Key functionalities include:  
- **Minting NFTs:** Allows users to mint a song NFT upon successful payment.
- **Royalty Collection:** Accumulates royalties (set at 30% per transaction) for the artist.
- **Metadata Management:** Stores audio URI and cover image URI for each token.

Key code snippet:
```solidity
function mintNFT(address _to) external payable returns (uint256) {
    require(msg.value >= nftPrice, "Insufficient payment");
    _currentTokenId++;
    uint256 newTokenId = _currentTokenId;
    uint256 royaltyAmount = msg.value.mul(ROYALTY_PERCENTAGE).div(100);
    royaltyBalance = royaltyBalance.add(royaltyAmount);
    _safeMint(_to, newTokenId);
    _setTokenURI(newTokenId, audioURI);
    emit NFTMinted(newTokenId, _to, msg.value);
    emit RoyaltyCollected(newTokenId, royaltyAmount);
    return newTokenId;
}
```

### zkTune

The `zkTune` contract orchestrates the overall platform operations:  
- **Artist and User Management:** Registers new artists and users.
- **Song Management:** Registers songs, deploys associated `SongNFT` contracts, and maintains global listings.
- **Streaming Mechanism:** Manages song streaming by minting NFTs for first-time listeners and tracking stream counts.

Key code snippet:
```solidity
function streamSong(uint256 _songId) external payable songExists(_songId) returns (string memory) {
    Song storage song = songs[_songId];
    SongNFT songNFT = SongNFT(song.songNFTAddress);
    if (userHasNFT[_songId][msg.sender]) {
        return song.audioURI;
    } else {
        songNFT.mintNFT{value: msg.value}(msg.sender);
        userHasNFT[_songId][msg.sender] = true;
        song.streamCount++;
        userStreams[msg.sender].push(_songId);
        emit SongStreamed(_songId, msg.sender);
        return song.audioURI;
    }
}
```

---

## Prerequisites

- **Node.js:** Ensure Node.js is installed (v12 or later recommended).
- **Hardhat:** Development environment for compiling and deploying Solidity contracts.
- **MetaMask or similar wallet:** For interacting with deployed contracts on zkSync.
- **Solidity:** Version ^0.8.0 and the corresponding OpenZeppelin libraries.

---

## Installation and Setup

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/zktune.git
   cd zktune
   ```

2. **Install Dependencies:**
   ```bash
   npm install
   ```

3. **Configure Environment Variables:**

   Update the `.env` file
   ```dotenv
   PRIVATE_KEY=your_private_key
   ```

4. **Compile Contracts:**
   ```bash
   npx hardhat compile
   ```

---

## Deployment

The deployment script leverages `deployContract` for deploying the GeneralPaymaster and the zkTune contract. Modify the script in the `deploy/` folder as needed.

To deploy, run:
```bash
npx run deploy
```

> The script deploys:
> - **GeneralPaymaster** for handling transaction fees.
> - **zkTune** as the primary dApp contract managing artists, songs, and streaming.

---

**Check out the frontend folder:**
  ```
cd interface
  ```
For detail on running the frontend, check [interface](https://github.com/rocknwa/music-streaming-and-tipping-platform/tree/main/interface)
 
## Usage

- **Artists:** Register via the platform and add songs. Each song deploys a dedicated NFT contract.
- **Listeners:** Stream songs by paying the required fee, which mints an NFT to confirm their access.
- **Royalty Payouts:** Artists can claim accumulated royalties by calling the payout function on the `SongNFT` contract.

Integration with zkSync’s native paymaster facilitates seamless, gas-efficient transactions for both artists and users.

---

## Contributing

Contributions are welcome! Please follow these guidelines:
- Fork the repository and create your branch from `main`.
- Ensure your code adheres to the Solidity Style Guide and OpenZeppelin best practices.
- Submit a pull request with detailed explanations of the changes.

For major changes, please open an issue first to discuss what you would like to change.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Acknowledgements

- [zkSync](https://zksync.io) – For enabling scalable Ethereum transactions.
- [OpenZeppelin](https://openzeppelin.com/contracts/) – For providing secure and community-validated smart contract libraries.
- The open-source community for invaluable support and contributions.

