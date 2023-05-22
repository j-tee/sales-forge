module StockHelpers
    include StoreHelpers
  
    def get_stock_id
      stock_id = params[:stock_id]
      return stock_id if stock_id.to_i > 0
  
      store_id = get_store_id
      stock = Stock.find_by(store_id: store_id)
      stock.id if stock
    end
  end
  