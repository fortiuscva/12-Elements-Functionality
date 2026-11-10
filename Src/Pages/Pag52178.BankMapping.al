page 52178 "12E Bank Mapping"
{
    ApplicationArea = All;
    Caption = 'Bank Mapping';
    PageType = List;
    SourceTable = "12E Bank Mapping";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(DdaAccount; Rec.DdaAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DdaAccount field.', Comment = '%';
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. field.', Comment = '%';
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bank Account Name field.', Comment = '%';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
                field("Balance at Date"; Rec."Balance at Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance at Date field.', Comment = '%';
                }
                field("Net Change"; Rec."Net Change")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Change field.', Comment = '%';
                }
            }
        }
    }
}
