class Merchants::BulkDiscountsController < ApplicationController
  before_action :find_merchant
  before_action :find_bulk_discount, only: [:show, :edit, :update, :destroy]



  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    if @bulk_discount.has_pending_invoice_items?
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/#{params[:id]}"
    else
      if @bulk_discount.update(
        quantity_threshold: params[:bulk_discount][:quantity_threshold],
        percentage_discount: params[:bulk_discount][:percentage_discount]
      )
        redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/#{params[:id]}"
      else
        render :edit
      end
    end
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    @bulk_discount = @merchant.bulk_discounts.build(bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    end
  end

  def destroy
    if @bulk_discount.has_pending_invoice_items?
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
    else
      BulkDiscount.destroy(params[:id])
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
    end
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end
end
