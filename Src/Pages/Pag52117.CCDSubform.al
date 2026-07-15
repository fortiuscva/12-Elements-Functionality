page 52117 "12E CCD Subform"
{
    ApplicationArea = All;
    Caption = 'CCD Subform';
    PageType = ListPart;
    SourceTable = "12E CCD Line";
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
                field("Call Date"; Rec."Call Date")
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
                field("Handling Time"; Rec."Handling Time")
                {
                    ToolTip = 'Specifies the value of the Handling Time field.', Comment = '%';
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.', Comment = '%';
                }
                field("Distribution Total"; Rec."Distribution Total")
                {
                    ToolTip = 'Specifies the value of the Distribution Total field.', Comment = '%';
                }
                field("No. of Hours"; Rec."No. of Hours")
                {
                    ToolTip = 'Specifies the value of the No. of Hours field.', Comment = '%';
                }
                field("Distributed Quantity"; Rec."Distributed Quantity")
                {
                    ToolTip = 'Specifies the value of the Distributed Quantity field.', Comment = '%';
                }
                //     field("Sales Invoice No."; Rec."Sales Invoice No.")
                //     {
                //         ToolTip = 'Specifies the value of the Sales Invoice No. field.', Comment = '%';
                //     }
                //     field("Sales Invoice Line No."; Rec."Sales Invoice Line No.")
                //     {
                //         ToolTip = 'Specifies the value of the Sales Invoice Line No. field.', Comment = '%';
                //     }
            }
        }
    }
}
