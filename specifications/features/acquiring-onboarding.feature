
@onboarding @actor_field_agent
Feature: Onboarding new Merchant with Acquiring Product

  As a FA I want to fill the merchant KYC information, select the acquiring product,
  negotiate and define their blended acquiring fee and link the terminal that I have in my backpack.
  Signing up a new merchant with a store requires KYC data, extra fields to configure the product and the agreed upon fee.

  Background:
    Given a Field Agent is logged-in

  Scenario Outline: Onboarding successful
    Given the user submits the <KYC> and <product configuration> data
    When the merchant is successfully onboarded
    Then I expect a <merchant> to be created
    And I expect a <store> to be created
    And I expect a <product subscription> to be set up for the acquiring product
    And I expect the merchant to receive their <Salt log-in credentials>
    And I expect the successful <merchant log-in> to the portal and see the agreement
    And I expect the merchant to receive the <welcome email> with T_and_Cs and the agreed upon blended fees

    Examples:
      | KYC                         | product configuration          | merchant                            | store                            | product subscription            | merchant log-in                         | Salt log-in credentials                |
      | input/path/to/kyc_data.json | input/path/to/product_cfg.json | expected/path/to/merchant_data.json | expected/path/to/store_info.json | expected/path/to/prod_subs.json | input/path/to/merchant_login_creds.json | expected/path/to/authoriser_creds.json |
