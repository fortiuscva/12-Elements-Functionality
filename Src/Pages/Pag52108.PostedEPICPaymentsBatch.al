page 52108 "12E Posted EPIC Payments Batch"
{
    ApplicationArea = All;
    Caption = '12E Posted EPIC Payments Batch';
    PageType = Document;
    SourceTable = "12E Pstd EPIC Pay Batch Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Batch No."; Rec."Batch No.")
                {
                    ToolTip = 'Specifies the value of the Batch No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
            }
            part("Posted EPIC Payment Lines"; "12E Pstd EPIC Pay BatchSubform")
            {
                Caption = 'Lines';
                SubPageLink = "Batch No." = field("Batch No.");
            }
        }
    }
}
