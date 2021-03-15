require 'net/https'
require 'uri'

class FlightsController < ApplicationController
  def index
    env_key = ENV["TEST_ENV_KEY"]
    secret = ENV["TEST_SECRET"]
    uri = URI.parse("https://core.spreedly.com/v1/payment_methods.json")
    req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
    req.basic_auth(env_key, secret)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme = "https") do |http|
      http.request(req)
    end
    @payment_methods = JSON.parse(response.body)
  end

  def checkout
    @flight_selected = params[:airlines]
  end

  def on_payment_token_created
    @spreedly_token = params[:payment_method_token]
  end

  def transact_payment
    @payment_token = params[:payment_method_token]

    env_key = ENV["TEST_ENV_KEY"]
    secret = ENV["TEST_SECRET"]
    gateway_token = ENV["TEST_GATEWAY_TOKEN"]
    receiver_token = ENV["TEST_RECEIVER_TOKEN"]

    retain_payment = params.has_key?(:retain_payment)
    forward_to_receiver = params.has_key?(:forward_to_receiver)

    # Purchase with payment token using:
    # https://core.spreedly.com/v1/gateways/<gateway_token>/purchase.json
    uri = URI.parse("https://core.spreedly.com/v1/gateways/#{gateway_token}/purchase.json")
    @request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    @request.basic_auth(env_key, secret)
    @request.body =
      {
        transaction: {
          payment_method_token: @payment_token,
          amount: "100",
          currency_code: "USD",
          retain_on_success: "#{retain_payment}"
        }
      }.to_json

    @response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme = "https") do |http|
      http.request(@request)
    end
    if forward_to_receiver
      receiver_uri = URI.parse("https://core.spreedly.com/v1/receivers/#{receiver_token}/deliver.json")
      receiver_request = Net::HTTP::Post.new(receiver_uri, 'Content-Type' => 'application/json')
      receiver_request.basic_auth(env_key, secret)
      receiver_request.body =
        {
          delivery: {
            payment_method_token: @payment_token,
            url: "https://spreedly-echo.herokuapp.com",
            headers: "Content-Type: application/json",
            body: "{ \"product_id\": \"916598\"}"
          }
        }.to_json
      receiver_response = Net::HTTP.start(receiver_uri.hostname, receiver_uri.port, use_ssl: receiver_uri.scheme = "https") do |http|
        http.request(receiver_request)
      end
    end
  end
end