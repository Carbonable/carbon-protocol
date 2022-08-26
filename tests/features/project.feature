Feature: Project

  Feature Description: Project contract provides functionnalities to allow a user to set up metadata.
  All corresponding actions must work as expected.

  Background:
    Given a deployed user contracts
    And an admin with address 1000
    And an anyone with address 1001
    Given a deployed project nft contact
    And owned by admin

  Scenario: Setters
    When admin set up the image url
    Then no failed transactions expected