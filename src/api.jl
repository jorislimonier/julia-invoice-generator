module api

using HTTP
using Parameters
using JSON
include("data.jl")


@with_kw struct Invoice
    from::String = "Joris LIMONIER"
    to::String = "helene"
    date::String = date = "19/06/2022"
    items::String = """[Dict("name"=> "Shop automation service","quantity"=> 1,"unit_cost"=> 5000)]"""
end

eval_string(str) = eval(Meta.parse(str::String))

function get_invoice_info(order::data.DataFrames.DataFrameRow)
    invoice_info = Dict{Any,Any}()

    # from is
    invoice_info["from"] = "Joris LIMONIER"

    # invoice_id
    invoice_id = order["invoice_id"]
    invoice_info["number"] = invoice_id

    # date
    date = order["date"]
    invoice_info["date"] = date

    # to
    customer_id = order["customer_id"]
    customer_info = filter(row -> row["customer_id"] == customer_id, data.customers)[1, :]

    invoice_info["to"] = customer_info["name"]

    # currency
    currency = order["currency"]
    invoice_info["currency"] = currency

    # products_id stores a list
    products_id = api.eval_string(String(order["products_id"]))

    items = []
    for product_id in products_id
        product = filter(row -> row["product_id"] == product_id, data.products)[1, :]
        name = product["name"]
        quantity = product["quantity"]
        unit_cost = product["unit_cost"]
        push!(items, Dict("name" => name, "quantity" => quantity, "unit_cost" => unit_cost))
    end
    invoice_info["items"] = items
    invoice_info["notes"] = "Thank you for your order."

    return invoice_info
end


"""
Sends a request and handle response.
Write to file if status if OK
"""
function connect_to_api_and_save_invoice_pdf(invoice_info::Dict{Any,Any}, invoice_id::Int)
    url = "https://invoice-generator.com"
    try
        # invoice_info["from"] = "Joris LIMONIER"
        response = HTTP.post(
            url,
            ["Content-Type" => "application/json"],
            body=JSON.json(invoice_info)
        )
        if response.status in [200, 201]
            open("data/invoices/invoice$(invoice_id).pdf", "w") do f
                write(f, response.body)
            end
        else
            print("Bad response status $(response.status)")
        end
    catch e
        println("Exception\n", e)
    end
end

end