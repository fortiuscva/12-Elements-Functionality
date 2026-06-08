page 52127 "12E Posted Lead Accruals"
{
    ApplicationArea = All;
    Caption = 'Posted Lead Accruals';
    PageType = List;
    SourceTable = "12E Posted Lead Accrual";
    CardPageId = "12E Posted Lead Accrual";
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
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                // field(Status; Rec.Status)
                // {
                //     ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                // }
            }
        }
    }
}
