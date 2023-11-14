class Merchants::BulkDiscountsController < ApplicationController
  before_action :find_merchant


  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def edit
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update 
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      render :edit
    end
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    @bulk_discount = @merchant.bulk_discounts.build(bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      render :new
    end
  end

  def destroy
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    @bulk_discount.destroy

    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end
end
