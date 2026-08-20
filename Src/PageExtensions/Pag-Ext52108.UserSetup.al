pageextension 52108 "12E User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("12E Allow CCD Invoice Deletion"; Rec."12E Allow CCD Invoice Deletion")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Allow CCD Invoice Deletion field.', Comment = '%';
            }
            field("12E Allow Pay Doc. Reversal"; Rec."12E Allow Pay Doc. Reversal")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Payroll Document Reversal field.', Comment = '%';
            }
            field("12E Allow Loyalty Reversal"; Rec."12E Allow Loyalty Reversal")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Loyalty Reversal field.', Comment = '%';
            }
        }
    }
}
