pageextension 52102 "12E Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        addlast(content)
        {
            field("12E CCD No."; Rec."12E CCD No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CCD No. field.', Comment = '%';
                Editable = false;
            }
            field("12E CCD Line No."; Rec."12E CCD Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CCD Line No. field.', Comment = '%';
                Editable = false;
            }
        }
    }
}
