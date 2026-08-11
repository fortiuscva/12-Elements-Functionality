page 52158 "12E Posted CCD Details"
{
    ApplicationArea = All;
    Caption = 'Posted Contact Center Distributions';
    PageType = List;
    SourceTable = "12E Posted CCD Header";
    CardPageId = "12E Posted CCD";
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
            }
        }
    }
}
