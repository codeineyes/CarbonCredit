;; Carbon Credit Token Contract
(define-fungible-token carbon-credit)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-insufficient-balance (err u101))
(define-constant err-invalid-credit (err u102))
(define-constant err-invalid-verifier (err u103))

;; Data Variables
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

(define-map authorized-verifiers principal bool)

;; Read-only functions
(define-read-only (get-credit-info (credit-id uint))
    (map-get? credit-metadata { credit-id: credit-id })
)

(define-read-only (get-balance (account principal))
    (ft-get-balance carbon-credit account)
)

(define-read-only (is-authorized-verifier (verifier principal))
    (default-to false (map-get? authorized-verifiers verifier))
)

;; Admin functions
(define-public (add-verifier (verifier principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set authorized-verifiers verifier true))
    )
)

(define-public (remove-verifier (verifier principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set authorized-verifiers verifier false))
    )
)

;; Carbon Credit Management
(define-public (mint-credits (credit-id uint)
                           (project-name (string-ascii 50))
                           (location (string-ascii 50))
                           (vintage-year uint)
                           (quantity uint)
                           (verification-standard (string-ascii 20))
                           (recipient principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (try! (ft-mint? carbon-credit quantity recipient))
        (ok (map-set credit-metadata
            { credit-id: credit-id }
            {
                project-name: project-name,
                location: location,
                vintage-year: vintage-year,
                quantity: quantity,
                verification-standard: verification-standard,
                verified: false,
                verifier: tx-sender
            }
        ))
    )
)

;; Verification
(define-public (verify-credits (credit-id uint))
    (let ((credit (unwrap! (map-get? credit-metadata { credit-id: credit-id }) err-invalid-credit)))
        (begin
            (asserts! (is-authorized-verifier tx-sender) err-invalid-verifier)
            (ok (map-set credit-metadata
                { credit-id: credit-id }
                (merge credit { verified: true, verifier: tx-sender })
            ))
        )
    )
)

;; Trading Functions
(define-public (transfer (amount uint) (sender principal) (recipient principal))
    (begin
        (asserts! (>= (ft-get-balance carbon-credit sender) amount) err-insufficient-balance)
        (try! (ft-transfer? carbon-credit amount sender recipient))
        (ok true)
    )
)

;; Market Functions
(define-map listings
    { credit-id: uint }
    {
        seller: principal,
        price: uint,
        quantity: uint,
        active: bool
    }
)
