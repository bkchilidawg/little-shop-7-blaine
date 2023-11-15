# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# DISABLE_DATABASE_ENVIRONMENT_CHECK=1
# Transaction.destroy_all
# InvoiceItem.destroy_all
# Invoice.destroy_all
# Item.destroy_all
# Customer.destroy_all
# Merchant.destroy_all

@bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 15)
  @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 20, percentage_discount: 20)
Rake::Task['csv_load:all'].invoke