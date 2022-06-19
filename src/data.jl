module data

using DataFrames, CSV, OdsIO

customers = CSV.read("data/customers.csv", DataFrame)
products = CSV.read("data/products.csv", DataFrame)
orders = CSV.read("data/orders.csv", DataFrame)


end