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
    //ModifyAllowed = false;
    //Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                    Editable = false;
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                    Editable = false;
                }
                field("Handling Time"; Rec."Handling Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Handling Time field.', Comment = '%';
                    Editable = false;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage field.', Comment = '%';
                    Editable = false;
                }
                field("Distributed Quantity"; Rec."Distributed Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Distributed Quantity field.', Comment = '%';
                    Editable = false;
                }
                field("Billed By Partner"; Rec."Billed By Partner")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Billed By Partner field.', Comment = '%';
                }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Invoice No. field.', Comment = '%';
                    Editable = false;
                }
                field("Pstd. Sales Invoice No."; Rec."Pstd. Sales Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
}
