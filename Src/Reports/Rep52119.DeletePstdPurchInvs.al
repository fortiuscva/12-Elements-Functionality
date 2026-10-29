report 52119 "12E Delete Pstd. Purch. Invs."
{
    ApplicationArea = All;
    Caption = 'Delete Posted Purchase Invoices';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem(PurchInvHeader; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            dataitem(PurchInvLine; "Purch. Inv. Line")
            {
                DataItemLinkReference = PurchInvHeader;
                DataItemLink = "Document No." = field("No.");
                trigger OnAfterGetRecord()
                begin
                    PurchInvLine.Delete(true);
                end;
            }
            trigger OnPostDataItem()
            begin
                PurchInvHeader.Delete(true);
            end;
        }
    }
}
