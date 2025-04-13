// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ERC721URIStorage extension from OpenZeppelin, which includes storage based token URI management
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// Import the Ownable contract from OpenZeppelin, which provides basic authorization control
import "@openzeppelin/contracts/access/Ownable.sol";

// Import the SafeMath library from OpenZeppelin to safely handle arithmetic operations
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Define the main contract SongNFT that inherits from ERC721URIStorage and Ownable
contract SongNFT is ERC721URIStorage, Ownable {
    using SafeMath for uint256; // Use SafeMath for uint256 to prevent overflow and underflow

    uint256 private _currentTokenId; // Private variable to track the current token ID
    uint256 public nftPrice;         // Public variable to store the price of the NFT
    address public artist;           // Public variable to store the address of the artist
    string public audioURI;          // Public variable to store the URI of the audio file
    uint256 public royaltyBalance;   // Public variable to store the balance of royalties
    string public coverURI;          // Public variable to store the URI of the cover image

    // Define a struct to store NFT information
    struct NFTInfo {
        uint256 nftPrice;           // Price of the NFT
        address artist;             // Address of the artist
        string audioURI;            // URI of the audio file
        string coverURI;            // URI of the cover image
        uint256 royaltyBalance;     // Balance of royalties
        uint256 currentTokenId;     // Current token ID
    }

    // Constant to define the royalty percentage (30%)
    uint256 public constant ROYALTY_PERCENTAGE = 30;

    // Event emitted when an NFT is minted
    event NFTMinted(uint256 indexed tokenId, address indexed buyer, uint256 price);
    // Event emitted when royalties are collected
    event RoyaltyCollected(uint256 indexed tokenId, uint256 amount);
    // Event emitted when royalties are paid to the artist
    event RoyaltyPaid(address indexed artist, uint256 amount);

    // Modifier to check if the user owns at least one NFT
    modifier onlyMintedUser(address user) {
        require(balanceOf(user) > 0, "Don't own the NFT");
        _; // Continue execution
    }

    // Constructor to initialize the contract with the provided details
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _nftPrice, 
        string memory _audioURI, 
        address _artist, 
        string memory _coverURI
    ) ERC721(_name, _symbol) {
        nftPrice = _nftPrice;        // Set the NFT price
        audioURI = _audioURI;        // Set the audio URI
        coverURI = _coverURI;        // Set the cover URI
        artist = _artist;            // Set the artist address
        _currentTokenId = 0;         // Initialize current token ID to 0
    }

    // Function to mint a new NFT
    function mintNFT(address _to) external payable returns (uint256) {
        require(msg.value >= nftPrice, "Insufficient payment"); // Ensure sufficient payment

        _currentTokenId++; // Increment current token ID
        uint256 newTokenId = _currentTokenId; // Assign new token ID

        // Calculate and accumulate royalty
        uint256 royaltyAmount = msg.value.mul(ROYALTY_PERCENTAGE).div(100);
        royaltyBalance = royaltyBalance.add(royaltyAmount);

        // Mint the NFT to the specified address
        _safeMint(_to, newTokenId);
        _setTokenURI(newTokenId, audioURI); // Set the token URI to the audio URI

        emit NFTMinted(newTokenId, _to, msg.value); // Emit NFTMinted event
        emit RoyaltyCollected(newTokenId, royaltyAmount); // Emit RoyaltyCollected event

        return newTokenId; // Return the new token ID
    }

    // Function to pay accumulated royalties to the artist
    function payRoyalties() external {
        uint256 amount = royaltyBalance; // Get the royalty balance
        royaltyBalance = 0; // Reset the royalty balance

        (bool success, ) = payable(artist).call{value: amount}(""); // Transfer the royalties to the artist
        require(success, "Royalty payout failed"); // Ensure the payout was successful

        emit RoyaltyPaid(artist, amount); // Emit RoyaltyPaid event
    }

    // Function to get NFT information for a specific user
    function getInfo(address user) external view onlyMintedUser(user) returns (NFTInfo memory) {
        // Return the NFT information
        return NFTInfo({
            nftPrice: nftPrice,
            artist: artist,
            audioURI: audioURI,
            coverURI: coverURI,
            royaltyBalance: royaltyBalance,
            currentTokenId: _currentTokenId
        });
    }
}
