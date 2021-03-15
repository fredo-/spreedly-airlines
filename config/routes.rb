Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'flights#index'
  post "/checkout", to: "flights#checkout"
  post "/receive_spreedly_token", to: "flights#on_payment_token_created"
  post "/confirm_transaction", to: "flights#transact_payment"
end
