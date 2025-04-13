This is a [zkSync](https://zksync.io) + [ethers v6](https://docs.ethers.org/v6/) + [Next.js](https://nextjs.org) project bootstrapped with [`zksync-cli`](https://github.com/matter-labs/zksync-cli)

# Getting Started

update the .env file with appropriate  values

Run `npm run dev` in your terminal, and then open [localhost:3000](http://localhost:3000) in your browser.

Once the webpage has loaded, changes made to files inside the `src/` directory (e.g. `src/pages/index.tsx`) will automatically update the webpage.

# Learn more

To learn more about [zkSync](https://zksync.io) or [ethers v6](https://docs.ethers.org/v6/), check out the following resources:

- [zkSync Documentation](https://era.zksync.io/docs/dev) – learn about zkSync features and API.
- [ethers v6 Documentation](https://docs.ethers.org/v6/) – learn about Ethers v6 and API.
- [Next.js Documentation](https://nextjs.org/docs) learn about Next.js features and API.



---

# Frontend Architecture

The frontend is built using a React/Next.js template integrated with Wagmi and the zksync-cli. The design emphasizes reusability, modularity, and adherence to best practices, ensuring a maintainable codebase that scales with feature enhancements and future integrations.

---

## Key Components

### Wallet Connection Management

The wallet connection mechanism is encapsulated in a dedicated context (`Context.tsx`). This component manages the complete lifecycle of wallet interactions and ensures a consistent experience across the application. The key responsibilities include:

- **Account State Management:**  
  Maintains the connected wallet address and monitors the connection status.

- **Network Information and Switching:**  
  Stores details about the currently active network and provides functionality to switch networks seamlessly.

- **Connection Lifecycle Functions:**
  - **`connect()`:** Initiates the wallet connection, updating the component state to reflect the active connection.
  - **`disconnect()`:** Resets the wallet connection state, effectively disconnecting the user by reverting the context to its default state.
  
- **Blockchain Interaction Helpers:**
  - **`getProvider()`:** Returns the provider object for performing read operations.
  - **`getSigner()`:** Returns the signer object required for signing transactions.

These exported functions are critical for ensuring that wallet-related interactions are handled consistently and can be easily reused wherever needed in the application.

### Song Playback Functionality

The song playback logic is implemented in the `usePlaySong.tsx` module. This component underpins the core functionality of our music streaming service by managing the workflow for playing songs. Key exports include:

- **`playSong`:**  
  The primary function that orchestrates the song playback process. Upon user interaction:
  - It verifies whether the user has already minted the song’s NFT.
  - If the NFT exists in the user’s wallet, it directly retrieves song data from the smart contract.
  - If not, it seamlessly triggers the minting process via our integrated Paymaster—thereby covering gas fees—and then plays the song.
  
- **`currentSong` and `message`:**  
  These exports assist in tracking playback state and delivering user feedback throughout the streaming experience.

### Decentralized File Storage via IPFS

Our dApp utilizes IPFS for decentralized file storage, ensuring that song files and associated metadata remain secure and tamper-proof. This functionality is implemented in the `uploadIPFS.tsx` component, which includes:

- **`uploadToIPFS`:**  
  Handles file uploads using the Pinata API, returning a unique CID that identifies the file on IPFS.

- **`isUploading`:**  
  A status flag indicating the upload progress, which is useful for managing UI state during the upload process.

- **`error`:**  
  Provides error logging for tracking and debugging issues during file uploads.

This approach leverages decentralized storage best practices and reinforces the trustless, secure architecture of our platform.

---

## Summary of Wallet Connection Exports

The following functions are essential for managing end-to-end wallet connection states:

- **`connect()`** – Initiates the wallet connection and updates the state accordingly.  
- **`disconnect()`** – Disconnects the wallet, effectively resetting the connection state.

---

This overview captures the core design principles behind the frontend of our dApp. Each component has been engineered to ensure a smooth, secure, and modular interaction pattern that aligns with the high standards expected in enterprise-grade decentralized applications.

For further details, please consult the individual component files in the repository.
