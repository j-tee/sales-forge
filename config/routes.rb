Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # resources :taxes
      post '/taxes/applyTaxToSpecificProducts', to: 'raxes#apply_tax_to_specific_products'
      post '/taxes/applyTax/:tax_id', to: 'taxes#apply_tax'
      post '/taxes/addTax', to: 'taxes#create'
      post '/taxes/addProductTax', to: 'taxes#add_product_tax'
      delete "/taxes/deleteProductTax/:product_id/:tax_id", to: "taxes#destroy_product_tax"
      get '/taxes/getTaxList/:store_id', to: 'taxes#tax_list'
      get '/taxes/getTaxesOnAProduct/:product_id', to: 'taxes#taxes_on_a_product'
      get '/taxes/getTaxedProducts/:store_id/:tax_id/:page/:per_page', to: 'taxes#taxed_products'
      get '/taxes/getTaxes/:order_id', to: 'taxes#get_taxes'
      get '/taxes/getProductWithoutTaxes/:store_id/:tax_id/:page/:per_page', to: 'taxes#without_taxes'
      get '/employees/getEmployees/:store_id', to: 'employees#index'
      get '/employees/getEmployee/:id', to: 'employees#show'
      post '/employees/addEmployee', to: 'employees#create'
      get '/payments/getPayments/:id/:order_id/:store_id', to: 'payments#index'
      get '/payments/getPaymentDetails/:store_id/:order_id/:startDate/:endDate/:page/:per_page', to: 'payments#payment_details'
      post '/payments/addPayment', to: 'payments#create'
      get '/stocks/getStocks/:store_id', to: 'stocks#index'
      post '/stocks/addStock', to: 'stocks#create'
      post '/order_line_items/addOrderLineItem', to: 'order_line_items#create'
      put '/order_line_items/updateOrderLineItem/:id', to: 'order_line_items#update'
      get '/order_line_items/getOrderLineItem/:id', to: 'order_line_items#show'
      get '/order_line_items/getOrderLineItems/:order_id/:customer_id/:product_id/:cur_page/:items_per_page',
          to: 'order_line_items#index'
      post '/orders/addOrder', to: 'orders#create'
      get '/orders/getOrder/:order_id', to: 'orders#show'
      get '/orders/getOrders/:store_id/:customer_id/:status', to: 'orders#index'
      get '/orders/getOrderDetails/:stock_id/:customer_id/:employee_id/:status/:page/:per_page', to: 'orders#order_details'
      post '/stores/registerStore', to: 'stores#create'
      get '/stores/:user_id', to: 'stores#index'
      post '/customers/addCustomer', to: 'customers#create'
      post '/customers/resetCustomer', to: 'customers#reset'
      get '/customers/getCustomerDetails/:store_id/:page/:per_page', to: 'customers#customer_details'
      get '/customers/getCustomers/:store_id', to: 'customers#index'
      get '/customers/getCustomer/:id', to: 'customers#show'
      post '/products/addProduct', to: 'products#create'
      post '/products/addNotification', to: 'products#add_notification'
      get '/products/getNotifications/:store_id', to: 'products#notifications'
      get '/products/getProduct/:id', to: 'products#show'
      get '/products/getProductWitoutASpecificTax/:tax_id', to: 'products#product_without_specific_tax'
      get '/stocks/getStock/:id', to: 'stocks#show'
      get '/products/getProducts/:store_id/:stock_id/:category_id/:cur_page/:items_per_page(/:product_name)(/:country)(/:manufacturer)(/:expdate)',
          to: 'products#index'
      get '/products/getUniqueListOfCountries/:stock_id', to: 'products#get_unique_countries'
      get '/products/getUniqueCosts/:stock_id/:category_id', to: 'products#get_unique_unit_costs'
      get '/products/getUniqueProducts/:stock_id/:category_id/:country', to: 'products#get_unique_product_names'
      get '/products/getUniqueProductNamesByStock/:stock_id', to: 'products#get_unique_product_per_stock'
      get '/products/getUniqueManufacturers/:stock_id/:category_id/:country/:product_name',
          to: 'products#get_unique_manafacturers'
      get '/categories/getCategories/:store_id', to: 'categories#index'
      post '/categories/addCategory', to: 'categories#create'
    end
  end
  get '/current_user', to: 'current_user#index'
  get '/users/:email', to: 'current_user#show_by_email'
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup',
                                 password: 'password'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       confirmations: 'users/confirmations',
                       passwords: 'users/passwords'
                     }
end
