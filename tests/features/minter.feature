Feature: Minter

  Feature Description: Minter contract provides functionnalities to allow a user to buy project NFTs.
  All corresponding actions must work as expected.

  Background:
    Given a deployed user contracts
    And an admin with address 1000
    And an anyone with address 1001
    Given a deployed project nft contact
    And owned by admin
    Given a deployed payment token contact
    And owned by admin
    And a total supply set to 1,000,000
    And anyone owns the whole supply
    Given a deployed minter contact
    And owned by admin
    And a whitelist sale open
    And a public sale close
    And a max buy per tx set to 5
    And an unit price set to 10
    And a max supply set to 10
    And a reserved supply set to 4
    Given a whitelist merkle tree
    And an allocation of 5 whitelist slots to anyone

  Scenario: Whitelisted
    When anyone approves minter for 5 token equivalent nfts
    And anyone makes 5 whitelist buy
    And admin open the public sale
    And anyone approves minter for 1 token equivalent nft
    And anyone makes 1 public buy
    And admin withdraw minter contract balance
    Then no failed transactions expected

  Scenario: Not whitelisted
    When admin set up a new whitelist merkle tree excluding anyone
    And anyone approves minter for 1 token equivalent nft
    And anyone makes 1 whitelist buy
    Then 'caller address is not whitelisted' failed transaction happens
    When admin open the public sale
    And anyone approves minter for 5 token equivalent nfts
    And anyone makes 5 public buy
    And admin withdraw minter contract balance
    Then no failed transactions expected

  Scenario: Airdrop
    When anyone approves minter for 5 token equivalent nfts
    And anyone makes 5 whitelist buy
    And admin open the public sale
    And anyone approves minter for 2 token equivalent nfts
    And anyone makes 2 public buy
    Then 'not enough available NFTs' failed transaction happens
    When admin airdrops 5 nfts to anyone
    Then 'not enough available reserved NFTs' failed transaction happens
    When admin airdrops 3 nfts to anyone
    And admin decreases reserved supply by 1
    And anyone makes 1 public buy
    And admin withdraw minter contract balance
    Then no failed transactions expected

  Scenario: Over-airdropped
    When admin airdrops 11 nfts to anyone
    Then 'not enough available NFTs' failed transaction happens