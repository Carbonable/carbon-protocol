Feature: Yielder

  Feature Description: Yield manager contract provides functionnalities to distribute reward tokens to stackers.
  All corresponding actions must work as expected.

  Background:
    Given a deployed user contracts
    And an admin with address 1000
    And an anyone with address 1001
    Given a deployed project nft contact
    And owned by admin
    Given a deployed reward token contact
    And owned by admin
    And a total supply set to 1,000,000
    And anyone owns the whole supply
    Given a deployed carbonable token contact
    And owned by admin
    And a total supply set to 1,000,000
    And anyone owns the whole supply
    Given a deployed yielder contract
    And owned by admin