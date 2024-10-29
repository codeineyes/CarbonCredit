# Carbon Credits Trading Platform

A decentralized marketplace for trading carbon credits built on the Stacks blockchain using Clarity smart contracts.

## Overview

This platform enables transparent, verifiable trading of carbon credits using blockchain technology. It implements a complete system for minting, verifying, and trading carbon credits while maintaining compliance with standard carbon offset verification processes.

## Features

- **Tokenized Carbon Credits**: Carbon credits are represented as fungible tokens
- **Verification System**: Multi-step verification process with authorized verifiers
- **P2P Trading**: Direct peer-to-peer trading capabilities
- **Marketplace**: Built-in marketplace for listing and purchasing credits
- **Metadata Storage**: Comprehensive tracking of credit origins and characteristics
- **Standards Compliance**: Built to support major carbon credit verification standards

## Smart Contract Structure

### Core Components

1. **Token Management**
```clarity
(define-fungible-token carbon-credit)
```
- Fungible token implementation for representing carbon credits
- Built-in balance tracking and transfer capabilities

2. **Credit Metadata**
```clarity
(define-map credit-metadata
    { credit-id: uint }
    {
        project-name: (string-ascii 50),
        location: (string-ascii 50),
        vintage-year: uint,
        quantity: uint,
        verification-standard: (string-ascii 20),
        verified: bool,
        verifier: principal
    }
)
```
- Stores detailed information about each credit batch
- Tracks verification status and history

3. **Market Functionality**
```clarity
(define-map listings
    { credit-id: uint }
    {
        seller: principal,
        price: uint,
        quantity: uint,
        active: bool
    }
)
```
- Enables creation of sell orders
- Manages active listings and purchases

## Key Functions

### Administrative Functions

1. **Add Verifier**
```clarity
(define-public (add-verifier (verifier principal))
```
- Adds new authorized verifiers to the system
- Restricted to contract owner

2. **Mint Credits**
```clarity
(define-public (mint-credits (credit-id uint) 
                           (project-name (string-ascii 50))
                           (location (string-ascii 50))
                           (vintage-year uint)
                           (quantity uint)
                           (verification-standard (string-ascii 20))
                           (recipient principal))
```
- Creates new carbon credits
- Associates metadata with credit batches

### Trading Functions

1. **Create Listing**
```clarity
(define-public (create-listing (credit-id uint) (price uint) (quantity uint))
```
- Lists credits for sale
- Sets price and quantity

2. **Purchase Listing**
```clarity
(define-public (purchase-listing (credit-id uint) (quantity uint))
```
- Executes purchase of listed credits
- Handles token and STX transfers

### Verification Functions

1. **Verify Credits**
```clarity
(define-public (verify-credits (credit-id uint))
```
- Marks credits as verified
- Can only be called by authorized verifiers

## Getting Started

### Prerequisites

- Stacks blockchain development environment
- Clarity CLI tools
- [Clarinet](https://github.com/hirosystems/clarinet) for testing

### Deployment

1. Clone the repository
2. Install dependencies
3. Deploy the contract to the Stacks blockchain
4. Initialize contract owner
5. Add authorized verifiers

### Usage Example

1. **Minting Credits**
```clarity
(contract-call? .carbon-credits mint-credits 
    u1 
    "Amazon Rainforest Protection"
    "Brazil"
    u2024
    u1000
    "VCS"
    'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
```

2. **Creating a Listing**
```clarity
(contract-call? .carbon-credits create-listing 
    u1
    u100000
    u500)
```

## Error Handling

The contract includes comprehensive error handling:
- `err-owner-only`: Operation restricted to contract owner
- `err-insufficient-balance`: Insufficient tokens for operation
- `err-invalid-credit`: Invalid credit ID or listing
- `err-invalid-verifier`: Unauthorized verifier

## Security Considerations

1. **Access Control**
    - Owner-only administrative functions
    - Verified-only operations
    - Balance checks before transfers

2. **Data Validation**
    - Input validation for all functions
    - Verification status checks
    - Balance verification before operations

## Future Enhancements

1. **Market Features**
    - Batch trading capabilities
    - Price discovery mechanisms
    - Auction functionality

2. **Verification**
    - Multi-signature verification
    - Verification history tracking
    - Additional verification standards

3. **Integration**
    - Oracle integration for pricing
    - Cross-chain bridge capabilities
    - Real-world data feeds

## Contributing

We welcome contributions to the Carbon Credits Trading Platform. Please submit pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions and support, please open an issue in the repository.

## Acknowledgments

- Carbon Credit Standards Organizations
- Stacks Blockchain Community
- Environmental Protection Projects

