module app

using HTTP
using Parameters
using JSON


@with_kw struct Invoice
    from::String = "joris"
    to::String = "helene"
    date::String = date = "19/06/2022"
    items::String = """[Dict("name"=> "Shop automation service","quantity"=> 1,"unit_cost"=> 5000)]"""
end

eval_string(str) = eval(Meta.parse(str::String))


"""
Sends a request and handle response.
Write to file if status if OK
"""
function connect_to_api_and_save_invoice_pdf()
    url = "https://invoice-generator.com"
    # try
    response = HTTP.post(
        url,
        ["Content-Type" => "application/json"],
        body=JSON.json(
            Dict(
                "from" => "joris",
                "to" => "helene"
            )
        )
    )
    if response.status in [200, 201]
        open("data/invoices/invoice0.pdf", "w") do f
            write(f, response.body)
        end
    else
        print("Bad response status $(response.status)")
        #     end
        # catch e
        #     println("Exception\n", e)
    end
end

end