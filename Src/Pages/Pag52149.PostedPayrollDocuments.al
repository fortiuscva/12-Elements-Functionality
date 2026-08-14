page 52149 "12E Posted Payroll Documents"
{
    ApplicationArea = All;
    Caption = 'Posted Payroll Documents';
    PageType = List;
    SourceTable = "12E Posted Payroll Header";
    CardPageId = "12E Posted Payroll Document";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Specifies the value of the Client ID field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    ToolTip = 'Specifies the value of the Pay Date field.', Comment = '%';
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period Start Date field.', Comment = '%';
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period End Date field.', Comment = '%';
                }
                field(Status; Rec."Status")
                {
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
                }
            }
        }
    }
}
