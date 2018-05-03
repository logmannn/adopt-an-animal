class OrderItemsController < ApplicationController

  def create
    @order = current_order
    @item = @order.order_items.new(item_params)
    @order.account_id = Account.find_or_initialize_by(user_id: current_user.id).id
    # added this \/
    @items = @order.order_items.pluck(:product_id)

    if @items.include? @item.product_id
      @existing_quantity = @order.order_items.where(product_id: @item.product_id).take.quantity
      @item_to_update = @order.order_items.where(product_id: @item.product_id)
      @quantity_to_add = item_params.values[0].to_i+@existing_quantity
      binding.pry
      @order.quantity = @quantity_to_add
    end
    @order.save

    session[:order_id] = @order.id
    respond_to do |format|
      format.html { redirect_to products_path}
      format.js { render :file => "layouts/create.js.erb" }
    end
  end

  def destroy
    @order = current_order
    @item = @order.order_items.find(params[:id])
    @item.destroy
    @order.save
    # respond_to do |format|
    #   format.html { redirect_to cart_path }
    #   format.js
    # end
    # redirect_to cart_path
  end

  private

  def item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
