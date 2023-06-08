class DiscountController < ApplicationController
  include StoreHelpers
  rescue_from StandardError, with: :handle_error
end
