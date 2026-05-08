page 52119 "12E CCD Doc with Loc Map"
{
    ApplicationArea = All;
    Caption = 'Call Center Distribution Document with Location Mapping';
    PageType = List;
    SourceTable = "12E CCD Doc with Loc Map";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
            }
        }
    }
}
