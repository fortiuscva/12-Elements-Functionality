page 52109 "12E Pstd EPIC Pay BatchSubform"
{
    ApplicationArea = All;
    Caption = 'Posted EPIC Payments Batch Subform';
    PageType = ListPart;
    SourceTable = "12E EPIC Payments Batch Line";
    UsageCategory = Lists;
    AutoSplitKey = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Batch No."; Rec."Batch No.")
                {
                    ToolTip = 'Specifies the value of the Batch No. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
            }
        }
    }
}
