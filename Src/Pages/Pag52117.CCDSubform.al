page 52117 "12E CCD Subform"
{
    ApplicationArea = All;
    Caption = 'CCD Subform';
    PageType = ListPart;
    SourceTable = "12E CCD Line";
    AutoSplitKey = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

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
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                    Visible = false;
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("Handling Time"; Rec."Handling Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Handling Time field.', Comment = '%';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage field.', Comment = '%';
                }
                field("Distributed Quantity"; Rec."Distributed Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Distributed Quantity field.', Comment = '%';
                }
            }
        }
    }
}
