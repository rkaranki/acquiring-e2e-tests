Feature: Acquiring onboarding

  Signing-up a new store for a merchant requires KYC data for the store (and
  for the company if it doesn’t exist in the system yet) and an acquiring
  solution to be set up.

  Scenario: Store KYC
    Given a Field Agent submits the store KYC through the application
    When the store is successfully onboarded
    Then I expect the merchant to receive an account activation e-mail for the store
    And I expect an user account to be created
    And I expect to retrieve the store details
    And I expect the acquiring solution to be set up
    And I expect a MID to be assigned to the store
