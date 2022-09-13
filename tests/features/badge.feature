Feature: Project

  Feature Description: Badge contract provides functionnalities to mint ERC-1155 tokens.
  All corresponding actions must work as expected.

  Background:
    Given a deployed user contracts
    And an admin with address 1000
    And an anyone with address 1001
    Given a deployed badge contact
    And an uri set to 'ipfs://carbonable/{id}.json'
    And a name set to 'Badge'
    And owned by admin

  Scenario: Mint and transfer
    When admin mints a token to anyone
    And anyone tries to transfer the token
    Then no failed transactions expected
    When admin locks token
    And anyone tries to transfer the token
    Then a failed transactions expected

  Scenario: Mint not owner
    When anyone mints a token to anyone
    Then a failed transactions expected