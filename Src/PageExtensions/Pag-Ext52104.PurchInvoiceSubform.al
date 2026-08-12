pageextension 52104 "12E Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        addlast(PurchDetailLine)
        {

            field("12E CCD No."; Rec."12E CCD No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the CCD No. field.', Comment = '%';
            }
            field("12E CCD Line No."; Rec."12E CCD Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the CCD Line No. field.', Comment = '%';
            }
        }
    }
}
