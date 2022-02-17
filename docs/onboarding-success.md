# Onboarding E2E flow

For the time being the E2E trigger comes from the Onboarding Backend for Frontend (BFF) and not from the Onboarding UI call to BFF. In time this will be evaluated to assess how feasible it is to have the E2E test start one system upstream.

Even though we are doing blackbox testing, some business rules should also be checked. As such the test is more of greybox in the sense that it crosses a bit the blackbox boundary to ensure the merchant is known to all the relevant systems.

```mermaid
sequenceDiagram
  participant TS as Testing System
  participant BFF as (Testing System as) <br/> Onboarding BFF
  participant GOP as Global Onboarding <br/> Platform
  participant AGW as Acquiring Gateway


  %%
  %% New merchant
  %%

  Note over BFF: A new merchant needs to have <br/> a person responsible for a company <br/> which manages a store

  BFF ->> GOP: POST /api/v1/people
  GOP -->> BFF: 201 Created <br/> ({id})
  
  BFF ->> GOP: POST api/v1/companies <br/> (authorizer_id: {id})
  GOP -->> BFF: 201 Created <br/> ({company/id})

  BFF ->> GOP: POST api/v1/stores <br/> (company_id: {company/id})
  GOP -->> BFF: 201 Created <br/> ({store/id})


  TS ->> AGW: GET /api/v1/signups/{store/id}
  AGW -->> TS: 200 OK <br/> (status: SIGNUP_INITIATED, <br/> mid, tid: null, <br/> kyc: done, <br/> acquiring_host: not_set, <br/> payments_gateway: not_set, <br/> terminal_management: not_set, <br/> payouts: ready)

  %%
  %% Acquiring services
  %%

  Note over BFF: Signup for acquiring services

  BFF ->> GOP: POST /api/v1/sign_up <br/> (store_id: {store/id} <br/> partner_slug: 'acquiring-gateway-system' <br/> extra_fields: null)
  GOP -->> BFF: 200 OK <br/> ({store/id})

  TS ->> AGW: GET /api/v1/signups/{store/id}
  AGW -->> TS: 200 OK <br/> (status: SIGNUP_INITIATED, <br/> mid, tid: null, <br/> kyc: done, <br/> acquiring_host: not_set, <br/> payments_gateway: not_set, <br/> terminal_management: not_set, <br/> payouts: ready)


  %%
  %% Acquiring host
  %%

  Note over BFF: Subscribe to an acquiring provider

  Note over BFF: ??? <br/> how do we get the _acquiring_service_id_ for next call
  BFF ->> GOP: POST /api/v1/subscriptions <br/> (billing_entity_id: '_doesn't matter_') <br/> items/extra_fields: {charge_type, amount_type, tariff_type, percent} <br/> items/service_id: '_acquiring_service_id_') <br/> price: {amount, currency, interval}, <br/> store_id: {store/id})
  GOP -->> BFF: 200 OK

  TS ->> AGW: GET /api/v1/signups/{store/id}
  AGW -->> TS: 200 OK <br/> (status: SIGNUP_INITIATED, <br/> mid, tid: null, <br/> kyc: done, <br/> acquiring_host: ready, <br/> payments_gateway: not_set, <br/> terminal_management: not_set, <br/> payouts: ready)

  %%
  %% Terminal
  %%

  Note over BFF: Setup a terminal

  Note over BFF: ??? <br/> how do we get the _terminal_service_id_ for next call
  BFF ->> GOP: POST /api/v1/subscriptions <br/> (billing_entity_id: '_doesn't matter_') <br/> items/extra_fields: {serialNumber} <br/> items/service_id: '_terminal_service_id_') <br/> price: {amount, currency, interval}, <br/> store_id: {store/id})
  GOP -->> BFF: 200 OK

  TS ->> AGW: GET /api/v1/signups/{store/id}
  AGW -->> TS: 200 OK <br/> (status: SIGNUP_COMPLETED, <br/> mid, tid: null, <br/> kyc: done, <br/> acquiring_host: ready, <br/> payments_gateway: ready, <br/> terminal_management: ready, <br/> payouts: ready)




```
