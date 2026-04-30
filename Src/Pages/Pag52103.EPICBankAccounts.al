page 52103 "12E EPIC Bank Accounts"
{
    ApplicationArea = All;
    Caption = 'EPIC Bank Accounts';
    PageType = List;
    SourceTable = "12E EPIC Bank Account";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Data Source ID"; Rec."Data Source ID")
                {
                    ToolTip = 'Specifies the value of the Data Source ID field.', Comment = '%';
                }
                field(Endpoint; Rec.Endpoint)
                {
                    ToolTip = 'Specifies the value of the Endpoint field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                }
                field("Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                }
            }
        }
    }
}
