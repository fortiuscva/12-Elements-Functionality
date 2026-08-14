page 52157 "12E Posted CCD Subform"
{
    ApplicationArea = All;
    Caption = 'Posted CCD Subform';
    PageType = ListPart;
    SourceTable = "12E Posted CCD Line";
    UsageCategory = None;
    AutoSplitKey = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("Handling Time"; Rec."Handling Time")
                {
                    ToolTip = 'Specifies the value of the Handling Time field.', Comment = '%';
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.', Comment = '%';
                }
                field("Distributed Quantity"; Rec."Distributed Quantity")
                {
                    ToolTip = 'Specifies the value of the Distributed Quantity field.', Comment = '%';
                }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Sales Invoice No. field.', Comment = '%';
                    Visible = false;
                }
                field("Pstd. Sales Invoice No."; Rec."Pstd. Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
}
