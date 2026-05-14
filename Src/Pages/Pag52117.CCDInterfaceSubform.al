page 52117 "12E CCD Interface Subform"
{
    ApplicationArea = All;
    Caption = 'CCD Interface Subform';
    PageType = ListPart;
    SourceTable = "12E CC Distribution Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("CCD Date"; Rec."CCD Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the CCD Date field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("Handle Time"; Rec."Handle Time")
                {
                    ToolTip = 'Specifies the value of the Handling Time field.', Comment = '%';
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.', Comment = '%';
                }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Sales Invoice No. field.', Comment = '%';
                }
                field("Sales Invoice Line No."; Rec."Sales Invoice Line No.")
                {
                    ToolTip = 'Specifies the value of the Sales Invoice Line No. field.', Comment = '%';
                }
            }
        }
    }
}
