page 52103 "12E EPIC GL Mapping List"
{
    ApplicationArea = All;
    Caption = 'EPIC GL Mappings';
    PageType = List;
    SourceTable = "12E EPIC GL Mapping";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Loan Status"; Rec."Loan Status")
                {
                    ToolTip = 'Specifies the value of the Loan Status field.', Comment = '%';
                }
                field("Data Source ID"; Rec."Data Source ID")
                {
                    ToolTip = 'Specifies the value of the Data Source ID field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Principal G/L Account No."; Rec."Principal G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the Principal G/L Account No. field.', Comment = '%';
                }
                field("Finance Fee G/L Account No."; Rec."Finance Fee G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the Finance Fee G/L Account No. field.', Comment = '%';
                }
                field("NSF Fee G/L Account No."; Rec."NSF Fee G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the NSF Fee G/L Account No. field.', Comment = '%';
                }
                field("Late Fee G/L Account No."; Rec."Late Fee G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the Late Fee G/L Account No. field.', Comment = '%';
                }
            }
        }
    }
}
