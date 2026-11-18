pageextension 52115 "Bank Account Ledger Entries" extends "Bank Account Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("12E Banking PK ID"; Rec."12E Banking PKID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Banking PK ID associated with this bank ledger entry.';
            }
        }
    }
}
