pageextension 52108 "12E User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("12E Allow CCD Invoice Deletion"; Rec."12E Allow CCD Invoice Deletion")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow CCD Invoice Deletion field.', Comment = '%';
            }
        }
    }
}
