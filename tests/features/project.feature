Feature: Project

  Feature Description: Project contract provides functionnalities to allow a user to set up metadata.
  All corresponding actions must work as expected.

  Background:
    Given a deployed user contracts
    And an admin with address 1000
    And an anyone with address 1001
    Given a deployed project contact
    And owned by admin

  Scenario: Setters
    When admin set up the image url
    And admin set up the external url
    And admin set up the description
    And admin set up the holder
    And admin set up the certifier
    And admin set up the land
    And admin set up the unit land surface
    And admin set up the country
    And admin set up the expiration
    And admin set up the total co2 sequestration
    And admin set up the unit co2 sequestration
    And admin set up the sequestration color
    And admin set up the sequestration type
    And admin set up the sequestration category
    And admin set up the background color
    And admin set up the animation url
    And admin set up the youtube url
    Then no failed transactions expected