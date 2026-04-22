page 52105 "12E 12 Elements Setup"
{
    ApplicationArea = All;
    Caption = '12 Elements Setup';
    PageType = Card;
    SourceTable = "12E 12 Elements Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("EPIC Payment Batch Nos."; Rec."EPIC Payment Batch Nos.")
                {
                    ToolTip = 'Specifies the value of the EPIC Payment Batch Nos. field.', Comment = '%';
                }
            }
        }
    }
}
