pageextension 52115 "Bank Account Ledger Entries" extends "Bank Account Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Banking PK ID"; Rec."Banking PK ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Banking PK ID associated with this bank ledger entry.';
            }
        }
    }
}
