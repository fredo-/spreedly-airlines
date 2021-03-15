# Spreedly-airlines

# Spreedly's Documentation
https://docs.spreedly.com/

# Set up
1. clone repo locally
1. set environment variables in your shell with the following names:
    ```editorconfig
   #example from ~/.zshrc:
   export TEST_ENV_KEY=[GET_FROM_SPREEDLY]
   export TEST_SECRET=[GET_FROM_SPREEDLY]
   export TEST_GATEWAY_TOKEN=[GET_FROM_SPREEDLY]
   export TEST_RECEIVER_TOKEN=[GET_FROM_SPREEDLY]
    ```
# Features
1. Home page
   1. Select a flight
   1. See retained payments
    
1. Checkout page
   1. Enter payment button
   
1. Spreedly's Express Modal/UI
   1. Enter payment info
   1. Show errors 
   1. Show helpful information like total, company name, and flight chosen
   
1. Payment confirmation page
   1. Retain payment
      - If selected, payment is retained and saved by spreedly for future use,
        i.e. displaying it in the Home page, below flight selection UI
      - Retained payment tokens are fetched from the `/v1/payment_methods` endpoint (base urls can be found in the 
        codebase)
   1. Forward payment to receiver
      - If selected, payment is forwarded to receiver corresponding to: `TEST_RECEIVER_TOKEN`
      - Forwarding is posted with the `/v1/receivers` endpoint
   1. Confirm button
      - Performs the purchase. If Retain payment was selected, you can see the new payment token retained in Home page