# include("src/data.jl")
include("src/api.jl")

function main()
    for order in eachrow(data.orders)
        invoice_id = order["invoice_id"]
        println("--- Generating invoice $invoice_id ---")
        invoice_info = api.get_invoice_info(order)
        api.connect_to_api_and_save_invoice_pdf(invoice_info, invoice_id)
    end
end


main()