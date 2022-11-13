Feature: Farmer

  Feature Description: Farmer contract provides functionnalities to distribute reward tokens to stackers.
  All corresponding actions must work as expected.

  Background:
    Given a deployed user contracts
    And an admin with address 1000
    And an anyone with address 1001
    Given a deployed project contact
    And owned by admin
    And with 2 tokens owned by admin
    And with 3 tokens owned by anyone
    Given a deployed farmer contract
    And owned by admin