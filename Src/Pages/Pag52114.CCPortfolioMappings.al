page 52114 "12E CC Portfolio Mappings"
{
    ApplicationArea = All;
    Caption = 'Call Center Portfolio Mappings';
    PageType = List;
    SourceTable = "12E CC Portfolio Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Portfolio; Rec.Portfolio)
                {
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("DataSource ID"; Rec."DataSource ID")
                {
                    ToolTip = 'Specifies the value of the DataSource ID field.', Comment = '%';
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.', Comment = '%';
                }
            }
        }
    }
}
