class Merchant::OrdersController < Merchant::BaseController



  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:order_id])
    @item = Item.find(params[:item_id])
    @item_order = ItemOrder.find_by(item_id: params[:item_id], order_id: params[:order_id])
    @item_order.update(status: "fulfilled")
    @item.modify_item_inventory(@item, @item_order.quantity, :decrease)
      flash[:success] = "Item has been fulfilled"
    redirect_to "/merchant/orders/#{@order.id}"
    if @order.item_orders.all? {|item_order| item_order.status == "fulfilled" }
      @order.update(status: "packaged")
    end
  end
end
