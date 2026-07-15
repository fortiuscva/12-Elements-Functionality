pageextension 52103 "12E Posted Sales Inv. Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addlast(content)
        {

            field("12E CCD No."; Rec."12E CCD No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CCD No. field.', Comment = '%';
            }
            field("12E CCD Line No."; Rec."12E CCD Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CCD Line No. field.', Comment = '%';
            }
        }
    }
}
