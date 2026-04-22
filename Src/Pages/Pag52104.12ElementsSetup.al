page 52104 "12E 12 Elements Setup"
{
    ApplicationArea = All;
    Caption = '12 Elements Setup';
    PageType = Card;
    SourceTable = "12E 12 Elements Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("EPIC Payment Batch Nos."; Rec."EPIC Payment Batch Nos.")
                {
                    ToolTip = 'Specifies the value of the EPIC Payment Batch Nos. field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group("EPIC Mappings")
            {
                action(EPICDataSourceMapping)
                {
                    ApplicationArea = all;
                    Caption = 'EPIC Data Source ID Mapping';
                    image = MapAccounts;
                    RunObject = page "12E EPIC Data Source Map List";
                }
                action(EPICGLMapping)
                {
                    ApplicationArea = all;
                    Caption = 'EPIC G/L Mapping';
                    image = MapAccounts;
                    RunObject = page "12E EPIC GL Mapping List";
                }
            }
            action(EPICPaymentTypes)
            {
                ApplicationArea = all;
                Caption = 'EPIC Payment Types';
                image = Payment;
                RunObject = page "12E EPIC Payment Types";
            }
            action(EPICBankAccounts)
            {
                ApplicationArea = all;
                Caption = 'EPIC Bank Accounts';
                image = Payment;
                RunObject = page "12E EPIC Bank Accounts";
            }
        }
    }
}
