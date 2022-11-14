Feature: Farmer

  Feature Description: Farmer contract provides functionnalities to distribute reward tokens to stackers.
  All corresponding actions must work as expected.

  Background:
    Given a deployed user contracts
    And an admin with address 1000
    And an anyone with address 1001
    Given a deployed project contact
    And owned by admin
    And with token 1 owned by admin
    And with token 2 owned by admin
    And with token 3 owned by anyone
    And with token 4 owned by anyone
    And with token 5 owned by anyone
    Given a deployed farmer contract
    And owned by admin