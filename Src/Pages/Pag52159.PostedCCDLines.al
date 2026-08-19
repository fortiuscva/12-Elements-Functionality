page 52159 "12E Posted CCD Lines"
{
    ApplicationArea = All;
    Caption = 'Posted CCD Lines';
    PageType = List;
    SourceTable = "12E Posted CCD Line";
    UsageCategory = None;
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
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
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
                field("No. of Hours"; Rec."No. of Hours")
                {
                    ToolTip = 'Specifies the value of the No. of Hours field.', Comment = '%';
                }
                field("Distributed Quantity"; Rec."Distributed Quantity")
                {
                    ToolTip = 'Specifies the value of the Distributed Quantity field.', Comment = '%';
                }
                field("Payroll Batch ID"; Rec."Payroll Batch ID")
                {
                    ToolTip = 'Specifies the value of the Pay Batch ID field.', Comment = '%';
                }
                field("Batch Start Date"; Rec."Batch Start Date")
                {
                    ToolTip = 'Specifies the value of the Pay Batch Start Date field.', Comment = '%';
                }
                field("Batch End Date"; Rec."Batch End Date")
                {
                    ToolTip = 'Specifies the value of the Pay Batch End Date field.', Comment = '%';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Purchase Invoice No. field.', Comment = '%';
                }
                // field("Invoice Date"; Rec."Invoice Date")
                // {
                //     ToolTip = 'Specifies the value of the Posted Purchase Invoice Date field.', Comment = '%';
                // }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Sales Invoice No. field.', Comment = '%';
                }
                field("Pstd. Sales Invoice No."; Rec."Pstd. Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
                }
                field("Batch or Inv. Hours"; Rec."Batch or Inv. Hours")
                {
                    ToolTip = 'Specifies the value of the Batch/Invoice Hours field.', Comment = '%';
                }
                field("Batch or Inv. Percentage"; Rec."Batch or Inv. Percentage")
                {
                    ToolTip = 'Specifies the value of the Batch/Invoice Hours Distribution Percentage field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(ShowDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Show Document';
                    Image = EditLines;
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    var
                        PostedCCDHeader: Record "12E Posted CCD Header";
                    begin
                        PostedCCDHeader.Reset();
                        PostedCCDHeader.SetRange("No.", Rec."Document No.");
                        Page.Run(Page::"12E Posted CCD", PostedCCDHeader);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Card_Promoted; ShowDocument)
                {
                }
            }
        }
    }
}
