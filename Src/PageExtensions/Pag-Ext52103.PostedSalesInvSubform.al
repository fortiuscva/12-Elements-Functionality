pageextension 52103 "12E Posted Sales Inv. Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {

            field("12E CCD No."; Rec."12E CCD No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CCD No. field.', Comment = '%';
                Editable = false;
                trigger OnDrillDown()
                var
                    PostedCCDHeader: Record "12E Posted CCD Header";
                begin
                    PostedCCDHeader.Reset();
                    PostedCCDHeader.SetRange("No.", Rec."12E CCD No.");
                    Page.RunModal(Page::"12E Posted CCD", PostedCCDHeader);
                end;
            }
            field("12E CCD Line No."; Rec."12E CCD Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CCD Line No. field.', Comment = '%';
                Editable = false;
                trigger OnDrillDown()
                var
                    PostedCCDLine: Record "12E Posted CCD Line";
                begin
                    PostedCCDLine.Reset();
                    PostedCCDLine.SetRange("Document No.", Rec."12E CCD No.");
                    PostedCCDLine.SetRange("Line No.", Rec."12E CCD Line No.");
                    Page.RunModal(Page::"12E Posted CCD Lines", PostedCCDLine);
                end;
            }
        }
    }
}
