pageextension 52110 "Posted Purchase Invoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("12E Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
