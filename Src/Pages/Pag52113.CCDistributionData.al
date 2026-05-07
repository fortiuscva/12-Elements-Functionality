page 52113 "12E CC Distribution Data"
{
    ApplicationArea = All;
    Caption = 'Call Center Distribution Data';
    PageType = List;
    SourceTable = "12E CC Distribution Data";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("CC Date"; Rec."CC Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("Handling Time"; Rec."Handling Time")
                {
                    ToolTip = 'Specifies the value of the Handling Time field.', Comment = '%';
                }
            }
        }
    }
}
