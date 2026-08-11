page 52156 "12E Posted CCD"
{
    ApplicationArea = All;
    Caption = 'Posted Contact Center Distribution';
    PageType = Document;
    SourceTable = "12E Posted CCD Header";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
            }
            part(Lines; "12E Posted CCD Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
}
