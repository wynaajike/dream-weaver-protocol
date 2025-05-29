;; Dream Weaver Protocol - Decentralized Lucid Dream Marketplace
;; Trade dream experiences, mine the collective unconscious, weave new realities
;; Create dream tokens from REM cycles, build nightmare defenses, unlock astral vaults

;; Contract constants
(define-constant contract-owner tx-sender)
(define-constant err-not-found (err u400))
(define-constant err-not-dreamer (err u401))
(define-constant err-dream-locked (err u402))
(define-constant err-insufficient-rem (err u403))
(define-constant err-nightmare-active (err u404))
(define-constant err-reality-unstable (err u405))
(define-constant err-lucidity-required (err u406))
(define-constant err-dream-fading (err u407))
(define-constant err-already-woven (err u408))
(define-constant err-void-breach (err u409))
(define-constant err-astral-blocked (err u410))

;; Data variables
(define-data-var next-dream-id uint u1)
(define-data-var next-weave-id uint u1)
(define-data-var next-portal-id uint u1)
(define-data-var rem-conversion-rate uint u1000) ;; REM to dream tokens
(define-data-var nightmare-threshold uint u13) ;; Unlucky number
(define-data-var lucidity-bonus uint u7)
(define-data-var collective-unconscious-depth uint u0)
(define-data-var reality-stability uint u100)
(define-data-var astral-tide-height uint u50)

;; Dream NFT trait
(define-trait dream-nft-trait
  (
    (get-owner (uint) (response (optional principal) uint))
    (transfer (uint principal principal) (response bool uint))
  )
)

;; Core data structures

;; Dreamer profiles
(define-map dreamers
  { dreamer: principal }
  {
    dream-name: (string-ascii 30),
    lucidity-level: uint, ;; 0-100
    rem-tokens: uint,
    nightmares-conquered: uint,
    dreams-woven: uint,
    astral-rank: (string-ascii 20), ;; "sleeper", "lucid", "architect", "void-walker"
    dream-signature: (buff 32),
    reality-anchors: uint,
    last-sleep-cycle: uint,
    is-awake: bool
  }
)

;; Dream experiences - the core tradeable asset
(define-map dream-experiences
  { dream-id: uint }
  {
    dreamer: principal,
    dream-type: (string-ascii 20), ;; "lucid", "prophetic", "nightmare", "astral", "shared"
    emotion-palette: (list 5 (string-ascii 20)),
    vividness: uint, ;; 1-100
    coherence: uint, ;; 1-100
    symbol-density: uint,
    tradeable: bool,
    price-in-rem: uint,
    dream-hash: (buff 32),
    captured-at: uint,
    reality-bleed: uint ;; How much it affects waking world
  }
)

;; Dream weaving - combining dreams into new realities
(define-map dream-weaves
  { weave-id: uint }
  {
    weaver: principal,
    component-dreams: (list 5 uint),
    weave-pattern: (string-ascii 30), ;; "tapestry", "mandala", "labyrinth", "constellation"
    stability: uint,
    reality-power: uint,
    manifestation-progress: uint, ;; 0-100
    void-touched: bool,
    participants: (list 10 principal)
  }
)

;; Nightmare entities - obstacles that must be conquered
(define-map nightmares
  { nightmare-id: uint }
  {
    origin-dream: uint,
    fear-type: (string-ascii 30),
    power-level: uint,
    defenders: (list 10 principal),
    damage-dealt: uint,
    rewards-pool: uint,
    conquered: bool,
    shadow-residue: uint
  }
)

;; Dream portals - gateways between dream realms
(define-map dream-portals
  { portal-id: uint }
  {
    creator: principal,
    source-realm: (string-ascii 30),
    destination-realm: (string-ascii 30),
    toll-in-rem: uint,
    travelers-count: uint,
    stability-cost: uint,
    portal-guardian: (optional principal),
    is-open: bool
  }
)

;; Collective unconscious pools
(define-map unconscious-pools
  { pool-theme: (string-ascii 30) }
  {
    total-contributions: uint,
    active-dreamers: uint,
    archetype-strength: uint,
    symbol-frequency: (list 10 (string-ascii 20)),
    reality-influence: uint,
    last-surge: uint
  }
)

;; Lucid techniques - skills that enhance dreaming
(define-map lucid-techniques
  { dreamer: principal, technique: (string-ascii 30) }
  {
    mastery-level: uint,
    uses-remaining: uint,
    power-multiplier: uint,
    side-effects: (optional (string-ascii 50))
  }
)

;; Reality anchors - prevent getting lost in dreams
(define-map reality-anchors
  { dreamer: principal, anchor-id: uint }
  {
    anchor-type: (string-ascii 20), ;; "memory", "totem", "promise", "fear"
    strength: uint,
    degradation-rate: uint,
    placed-at: uint
  }
)

;; Astral vaults - store powerful dream artifacts
(define-map astral-vaults
  { vault-owner: principal }
  {
    vault-level: uint,
    stored-dreams: (list 20 uint),
    void-shields: uint,
    access-keys: (list 5 principal),
    last-opened: uint,
    corruption-level: uint
  }
)

;; Dream marketplace listings
(define-map dream-market
  { dream-id: uint }
  {
    seller: principal,
    price: uint,
    currency: (string-ascii 10), ;; "rem" or "stx"
    listing-expiry: uint,
    preview-available: bool,
    times-viewed: uint
  }
)

;; Helper functions

;; Calculate dream value based on properties
(define-private (calculate-dream-value (vividness uint) (coherence uint) (symbol-density uint))
  (/ (+ (* vividness u3) (* coherence u2) symbol-density) u6)
)

;; Calculate lucidity bonus
(define-private (calculate-lucidity-bonus (base-amount uint) (lucidity-level uint))
  (+ base-amount (/ (* base-amount lucidity-level) u100))
)

;; Check reality stability
(define-private (check-reality-stable)
  (>= (var-get reality-stability) u30)
)

;; Min function
(define-private (min (a uint) (b uint))
  (if (<= a b) a b)
)

;; Max function
(define-private (max (a uint) (b uint))
  (if (>= a b) a b)
)

;; Helper function for list length as uint
(define-private (list-length-uint (lst (list 5 (string-ascii 20))))
  (len lst)
)

;; Public functions

;; Initialize as a dreamer
(define-public (enter-dreamscape (dream-name (string-ascii 30)))
  (let
    (
      (existing-dreamer (map-get? dreamers { dreamer: tx-sender }))
    )
    (asserts! (is-none existing-dreamer) err-already-woven)
    
    ;; Initialize dreamer profile
    (map-set dreamers
      { dreamer: tx-sender }
      {
        dream-name: dream-name,
        lucidity-level: u10, ;; Start with basic awareness
        rem-tokens: u100, ;; Welcome bonus
        nightmares-conquered: u0,
        dreams-woven: u0,
        astral-rank: "sleeper",
        dream-signature: 0x0000000000000000000000000000000000000000000000000000000000000000,
        reality-anchors: u3, ;; Start with 3 anchors
        last-sleep-cycle: block-height,
        is-awake: true
      }
    )
    
    ;; Initialize astral vault
    (map-set astral-vaults
      { vault-owner: tx-sender }
      {
        vault-level: u1,
        stored-dreams: (list),
        void-shields: u5,
        access-keys: (list),
        last-opened: block-height,
        corruption-level: u0
      }
    )
    
    (ok true)
  )
)

;; Enter sleep cycle to generate REM tokens
(define-public (enter-sleep-cycle (sleep-duration uint))
  (let
    (
      (dreamer (unwrap! (map-get? dreamers { dreamer: tx-sender }) err-not-dreamer))
      (blocks-since-last (- block-height (get last-sleep-cycle dreamer)))
    )
    ;; Check if enough time has passed (can't sleep constantly)
    (asserts! (>= blocks-since-last u144) err-dream-locked)
    
    ;; Check reality is stable enough to sleep
    (asserts! (check-reality-stable) err-reality-unstable)
    
    ;; Calculate REM tokens generated
    (let
      (
        (base-rem (/ (* sleep-duration (var-get rem-conversion-rate)) u1000))
        (bonus-from-lucidity (calculate-lucidity-bonus base-rem (get lucidity-level dreamer)))
        (total-rem (min bonus-from-lucidity u1000)) ;; Cap per cycle
      )
      ;; Update dreamer state
      (map-set dreamers
        { dreamer: tx-sender }
        (merge dreamer {
          rem-tokens: (+ (get rem-tokens dreamer) total-rem),
          last-sleep-cycle: block-height,
          is-awake: false
        })
      )
      
      ;; Return REM generated with spontaneous dream chance
      (ok { 
        rem-generated: total-rem, 
        spontaneous-chance: (> (mod block-height u100) u90) 
      })
    )
  )
)

;; Capture a dream experience
(define-public (capture-dream
  (dream-type (string-ascii 20))
  (emotion-palette (list 5 (string-ascii 20)))
  (vividness uint)
  (coherence uint)
  (dream-hash (buff 32)))
  (let
    (
      (dream-id (var-get next-dream-id))
      (dreamer (unwrap! (map-get? dreamers { dreamer: tx-sender }) err-not-dreamer))
    )
    ;; Check dreamer is in sleep state
    (asserts! (not (get is-awake dreamer)) err-lucidity-required)
    
    ;; Validate dream properties
    (asserts! (and (<= vividness u100) (<= coherence u100)) err-reality-unstable)
    
    ;; Calculate capture cost
    (let
      (
        (symbol-density (list-length-uint emotion-palette))
        (capture-cost (max u10 (calculate-dream-value vividness coherence symbol-density)))
      )
      ;; Check sufficient REM tokens
      (asserts! (>= (get rem-tokens dreamer) capture-cost) err-insufficient-rem)
      
      ;; Create dream experience
      (map-set dream-experiences
        { dream-id: dream-id }
        {
          dreamer: tx-sender,
          dream-type: dream-type,
          emotion-palette: emotion-palette,
          vividness: vividness,
          coherence: coherence,
          symbol-density: symbol-density,
          tradeable: true,
          price-in-rem: u0,
          dream-hash: dream-hash,
          captured-at: block-height,
          reality-bleed: (/ vividness u10)
        }
      )
      
      ;; Update dreamer
      (map-set dreamers
        { dreamer: tx-sender }
        (merge dreamer {
          rem-tokens: (- (get rem-tokens dreamer) capture-cost),
          dreams-woven: (+ (get dreams-woven dreamer) u1)
        })
      )
      
      ;; Update reality stability based on dream type
      (if (is-eq dream-type "nightmare")
        (var-set reality-stability (max u0 (- (var-get reality-stability) u5)))
        (if (is-eq dream-type "lucid")
          (var-set reality-stability (min u100 (+ (var-get reality-stability) u2)))
          true
        )
      )
      
      ;; Update dream ID counter
      (var-set next-dream-id (+ dream-id u1))
      
      ;; Increase collective unconscious depth
      (var-set collective-unconscious-depth (+ (var-get collective-unconscious-depth) u1))
      
      (ok dream-id)
    )
  )
)

;; Capture spontaneous dream (public version)
(define-public (capture-spontaneous-dream)
  (let
    (
      (dreamer (unwrap! (map-get? dreamers { dreamer: tx-sender }) err-not-dreamer))
      (dream-id (var-get next-dream-id))
      (random-type (if (> (mod block-height u10) u7) "prophetic" "astral"))
    )
    ;; Check dreamer is in sleep state
    (asserts! (not (get is-awake dreamer)) err-lucidity-required)
    
    ;; Check if conditions are right for spontaneous dream
    (asserts! (> (mod block-height u100) u90) err-reality-unstable)
    
    (map-set dream-experiences
      { dream-id: dream-id }
      {
        dreamer: tx-sender,
        dream-type: random-type,
        emotion-palette: (list "mystery" "wonder" "fear"),
        vividness: (+ u50 (mod block-height u50)),
        coherence: (+ u30 (mod block-height u70)),
        symbol-density: u3,
        tradeable: true,
        price-in-rem: u0,
        dream-hash: 0x0000000000000000000000000000000000000000000000000000000000000001,
        captured-at: block-height,
        reality-bleed: u20
      }
    )
    (var-set next-dream-id (+ dream-id u1))
    (ok { bonus-dream: dream-id })
  )
)

;; Trade dream on marketplace
(define-public (list-dream-for-sale (dream-id uint) (price uint) (currency (string-ascii 10)) (preview bool))
  (let
    (
      (validated-id (+ dream-id u0))
      (dream (unwrap! (map-get? dream-experiences { dream-id: validated-id }) err-not-found))
      (existing-listing (map-get? dream-market { dream-id: validated-id }))
    )
    ;; Check ownership
    (asserts! (is-eq tx-sender (get dreamer dream)) err-not-dreamer)
    
    ;; Check dream is tradeable
    (asserts! (get tradeable dream) err-dream-locked)
    
    ;; Check not already listed
    (asserts! (is-none existing-listing) err-already-woven)
    
    ;; List on market
    (map-set dream-market
      { dream-id: validated-id }
      {
        seller: tx-sender,
        price: price,
        currency: currency,
        listing-expiry: (+ block-height u1440), ;; ~10 days
        preview-available: preview,
        times-viewed: u0
      }
    )
    
    (ok true)
  )
)

;; Purchase dream from marketplace
(define-public (purchase-dream (dream-id uint))
  (let
    (
      (validated-id (+ dream-id u0))
      (listing (unwrap! (map-get? dream-market { dream-id: validated-id }) err-not-found))
      (dream (unwrap! (map-get? dream-experiences { dream-id: validated-id }) err-not-found))
      (buyer-profile (unwrap! (map-get? dreamers { dreamer: tx-sender }) err-not-dreamer))
    )
    ;; Check listing not expired
    (asserts! (< block-height (get listing-expiry listing)) err-dream-fading)
    
    ;; Process payment
    (if (is-eq (get currency listing) "rem")
      ;; Pay in REM tokens
      (begin
        (asserts! (>= (get rem-tokens buyer-profile) (get price listing)) err-insufficient-rem)
        (map-set dreamers
          { dreamer: tx-sender }
          (merge buyer-profile { rem-tokens: (- (get rem-tokens buyer-profile) (get price listing)) })
        )
        (map-set dreamers
          { dreamer: (get seller listing) }
          (merge (unwrap! (map-get? dreamers { dreamer: (get seller listing) }) err-not-found)
            { rem-tokens: (+ (get rem-tokens (unwrap! (map-get? dreamers { dreamer: (get seller listing) }) err-not-found)) (get price listing)) })
        )
      )
      ;; Pay in STX
      (try! (stx-transfer? (get price listing) tx-sender (get seller listing)))
    )
    
    ;; Transfer dream ownership
    (map-set dream-experiences
      { dream-id: validated-id }
      (merge dream { dreamer: tx-sender })
    )
    
    ;; Remove from market
    (map-delete dream-market { dream-id: validated-id })
    
    ;; Add reality bleed effect
    (var-set reality-stability (max u0 (- (var-get reality-stability) (get reality-bleed dream))))
    
    (ok true)
  )
)

;; Weave multiple dreams together
(define-public (weave-dreams
  (component-dreams (list 5 uint))
  (weave-pattern (string-ascii 30)))
  (let
    (
      (weave-id (var-get next-weave-id))
      (dreamer (unwrap! (map-get? dreamers { dreamer: tx-sender }) err-not-dreamer))
      (dream-count (len component-dreams))
    )
    ;; Validate dream count
    (asserts! (>= dream-count u2) err-insufficient-rem)
    
    ;; Check lucidity level for complex weaves
    (asserts! (>= (get lucidity-level dreamer) (* dream-count u10)) err-lucidity-required)
    
    ;; TODO: Verify ownership of all component dreams (simplified for now)
    
    ;; Calculate weave properties
    (let
      (
        (base-stability (- u100 (* dream-count u10)))
        (reality-power (* dream-count u20))
      )
      ;; Create weave
      (map-set dream-weaves
        { weave-id: weave-id }
        {
          weaver: tx-sender,
          component-dreams: component-dreams,
          weave-pattern: weave-pattern,
          stability: base-stability,
          reality-power: reality-power,
          manifestation-progress: u0,
          void-touched: false,
          participants: (list tx-sender)
        }
      )
      
      ;; Update weaver stats
      (map-set dreamers
        { dreamer: tx-sender }
        (merge dreamer {
          dreams-woven: (+ (get dreams-woven dreamer) u1),
          lucidity-level: (min u100 (+ (get lucidity-level dreamer) u5))
        })
      )
      
      ;; Update weave counter
      (var-set next-weave-id (+ weave-id u1))
      
      ;; Affect reality
      (var-set reality-stability (max u0 (- (var-get reality-stability) reality-power)))
      
      (ok weave-id)
    )
  )
)

;; Conquer nightmare
(define-public (confront-nightmare (nightmare-id uint) (power-committed uint))
  (let
    (
      (validated-id (+ nightmare-id u0))
      (nightmare (unwrap! (map-get? nightmares { nightmare-id: validated-id }) err-not-found))
      (dreamer (unwrap! (map-get? dreamers { dreamer: tx-sender }) err-not-dreamer))
    )
    ;; Check nightmare not already conquered
    (asserts! (not (get conquered nightmare)) err-already-woven)
    
    ;; Check sufficient REM tokens
    (asserts! (>= (get rem-tokens dreamer) power-committed) err-insufficient-rem)
    
    ;; Deduct REM tokens
    (map-set dreamers
      { dreamer: tx-sender }
      (merge dreamer { rem-tokens: (- (get rem-tokens dreamer) power-committed) })
    )
    
    ;; Add to defenders if not already there
    (let
      (
        (current-defenders (get defenders nightmare))
        (new-damage (+ (get damage-dealt nightmare) power-committed))
      )
      ;; Update nightmare
      (map-set nightmares
        { nightmare-id: validated-id }
        (merge nightmare {
          damage-dealt: new-damage,
          conquered: (>= new-damage (get power-level nightmare)),
          defenders: (if (is-none (index-of current-defenders tx-sender))
                       (unwrap! (as-max-len? (append current-defenders tx-sender) u10) err-astral-blocked)
                       current-defenders)
        })
      )
      
      ;; If conquered, distribute rewards
      (if (>= new-damage (get power-level nightmare))
        (begin
          ;; Update dreamer stats
          (map-set dreamers
            { dreamer: tx-sender }
            (merge dreamer {
              nightmares-conquered: (+ (get nightmares-conquered dreamer) u1),
              lucidity-level: (min u100 (+ (get lucidity-level dreamer) u10))
            })
          )
          ;; Restore some reality stability
          (var-set reality-stability (min u100 (+ (var-get reality-stability) u10)))
          (ok { conquered: true, damage-dealt: new-damage, shadow-residue: (get shadow-residue nightmare) })
        )
        (ok { conquered: false, damage-dealt: new-damage, shadow-residue: u0 })
      )
    )
  )
)

;; Create dream portal
(define-public (open-dream-portal
  (source-realm (string-ascii 30))
  (destination-realm (string-ascii 30))
  (toll-in-rem uint))
  (let
    (
      (portal-id (var-get next-portal-id))
      (dreamer (unwrap! (map-get? dreamers { dreamer: tx-sender }) err-not-dreamer))
    )
    ;; Check astral rank
    (asserts! (or (is-eq (get astral-rank dreamer) "architect") 
                  (is-eq (get astral-rank dreamer) "void-walker")) err-lucidity-required)
    
    ;; Calculate stability cost
    (let ((stability-cost (+ u20 (/ toll-in-rem u100))))
      ;; Check reality can handle it
      (asserts! (> (var-get reality-stability) stability-cost) err-reality-unstable)
      
      ;; Create portal
      (map-set dream-portals
        { portal-id: portal-id }
        {
          creator: tx-sender,
          source-realm: source-realm,
          destination-realm: destination-realm,
          toll-in-rem: toll-in-rem,
          travelers-count: u0,
          stability-cost: stability-cost,
          portal-guardian: none,
          is-open: true
        }
      )
      
      ;; Deduct reality stability
      (var-set reality-stability (- (var-get reality-stability) stability-cost))
      
      ;; Update portal counter
      (var-set next-portal-id (+ portal-id u1))
      
      (ok portal-id)
    )
  )
)

;; Wake up (required before entering new sleep cycle)
(define-public (wake-up)
  (let
    (
      (dreamer (unwrap! (map-get? dreamers { dreamer: tx-sender }) err-not-dreamer))
    )
    ;; Check if asleep
    (asserts! (not (get is-awake dreamer)) err-already-woven)
    
    ;; Wake up
    (map-set dreamers
      { dreamer: tx-sender }
      (merge dreamer { is-awake: true })
    )
    
    ;; Small reality stability boost for waking
    (var-set reality-stability (min u100 (+ (var-get reality-stability) u1)))
    
    (ok true)
  )
)

;; Read-only functions

;; Get dreamer profile
(define-read-only (get-dreamer (dreamer principal))
  (map-get? dreamers { dreamer: dreamer })
)

;; Get dream experience
(define-read-only (get-dream (dream-id uint))
  (map-get? dream-experiences { dream-id: dream-id })
)

;; Get dream weave
(define-read-only (get-weave (weave-id uint))
  (map-get? dream-weaves { weave-id: weave-id })
)

;; Get marketplace listing
(define-read-only (get-dream-listing (dream-id uint))
  (map-get? dream-market { dream-id: dream-id })
)

;; Get nightmare
(define-read-only (get-nightmare (nightmare-id uint))
  (map-get? nightmares { nightmare-id: nightmare-id })
)

;; Get portal
(define-read-only (get-portal (portal-id uint))
  (map-get? dream-portals { portal-id: portal-id })
)

;; Calculate dream compatibility for weaving
(define-read-only (check-dream-compatibility (dream-id-1 uint) (dream-id-2 uint))
  (let
    (
      (dream-1 (map-get? dream-experiences { dream-id: dream-id-1 }))
      (dream-2 (map-get? dream-experiences { dream-id: dream-id-2 }))
    )
    (match dream-1
      d1 (match dream-2
        d2 (ok {
          type-match: (is-eq (get dream-type d1) (get dream-type d2)),
          vividness-diff: (if (> (get vividness d1) (get vividness d2))
                            (- (get vividness d1) (get vividness d2))
                            (- (get vividness d2) (get vividness d1))),
          combined-bleed: (+ (get reality-bleed d1) (get reality-bleed d2))
        })
        err-not-found
      )
      err-not-found
    )
  )
)

;; Get protocol statistics
(define-read-only (get-dreamscape-stats)
  {
    total-dreams: (- (var-get next-dream-id) u1),
    total-weaves: (- (var-get next-weave-id) u1),
    total-portals: (- (var-get next-portal-id) u1),
    collective-depth: (var-get collective-unconscious-depth),
    reality-stability: (var-get reality-stability),
    astral-tide: (var-get astral-tide-height)
  }
)

;; Admin functions

;; Adjust reality stability
(define-public (stabilize-reality (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-dreamer)
    (var-set reality-stability (min u100 (+ (var-get reality-stability) amount)))
    (ok (var-get reality-stability))
  )
)

;; Update REM conversion rate
(define-public (set-rem-conversion-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-dreamer)
    (var-set rem-conversion-rate new-rate)
    (ok true)
  )
)