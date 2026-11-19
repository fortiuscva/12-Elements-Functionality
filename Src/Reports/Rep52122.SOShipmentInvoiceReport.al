
report 52122 "12E SO Shipment Invoice Report"
{
    Caption = 'Sales Order Shipment & Invoice Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = 'SOShipmentInvoice.rdl';

    dataset
    {
        // POSTED SALES SHIPMENTS
        dataitem(ShipmentLine; "Sales Shipment Line")
        {
            column(OrderNo; "Order No.") { }
            column(ShipmentNo; "Document No.") { }
            column(ShipmentDate; "Shipment Date") { }
            column(ItemNo; "No.") { }
            column(ShipmentDescription; Description) { }
            column(ShipmentQuantity; Quantity) { }

            trigger OnPreDataItem()
            begin
                if SalesOrderNo = '' then
                    Error('Please enter Sales Order No.');

                SetRange("Order No.", SalesOrderNo);
            end;
        }

        // POSTED SALES INVOICES
        dataitem(InvoiceLine; "Sales Invoice Line")
        {
            column(InvoiceOrderNo; "Order No.") { }
            column(InvoiceNo; "Document No.") { }
            column(InvoiceDate; InvoicePostingDate) { }
            column(InvoiceItemNo; "No.") { }
            column(InvoiceDescription; Description) { }
            column(InvoiceQuantity; Quantity) { }
            column(InvoiceAmount; Amount) { }

            trigger OnPreDataItem()
            begin
                SetRange("Order No.", SalesOrderNo);
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(InvoicePostingDate);
                if InvoiceHeader.Get("Document No.") then
                    InvoicePostingDate := InvoiceHeader."Posting Date";
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(SalesOrderNo; SalesOrderNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Order No.';

                        TableRelation = "Sales Header"."No."
                            where("Document Type" = const(Order));
                    }
                }
            }
        }
    }

    var
        SalesOrderNo: Code[20];
        InvoiceHeader: Record "Sales Invoice Header";
        InvoicePostingDate: Date;
}
