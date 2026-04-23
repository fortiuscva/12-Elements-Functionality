page 52110 "12E Pstd. EPIC Pmts Batch List"
{
    ApplicationArea = All;
    Caption = 'Posted EPIC Payments Batch List';
    PageType = List;
    SourceTable = "12E Pstd EPIC Pay Batch Header";
    CardPageId = "12E EPIC Payments Batch";
    UsageCategory = Lists;
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
