page 52114 "12E CCDPort. Cust. Map. Detail"
{
    ApplicationArea = All;
    Caption = 'CCD Portfolio Customer Mapping Details';
    PageType = List;
    SourceTable = "12E CCD Port. Cust. Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
            }
        }
    }
}
