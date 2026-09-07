page 52172 "12E Posted LMS Trans. Details"
{
    ApplicationArea = All;
    Caption = 'Posted LMS Transaction Details';
    PageType = List;
    SourceTable = "12E Posted LMS Trans. Details";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("LMS Document No."; Rec."LMS Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LMS Document No. field.', Comment = '%';
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("PK ID"; Rec."PK ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field("DW Load Date"; Rec."DW Load Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DW Load Date field.', Comment = '%';
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan ID field.', Comment = '%';
                }
                field("Payment ID"; Rec."Payment ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment ID field.', Comment = '%';
                }
                field("Transaction ID"; Rec."Transaction ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction ID field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Type field.', Comment = '%';
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Status field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field(Store; Rec.Store)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store field.', Comment = '%';
                }
                field(Processor; Rec.Processor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processor field.', Comment = '%';
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Code field.', Comment = '%';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debit Account No. field.', Comment = '%';
                }
                field("Credit Account No."; Rec."Credit Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Credit Account No. field.', Comment = '%';
                }
                field("Payment Agent"; Rec."Payment Agent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Agent field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                }
                field("ERP Status"; Rec."ERP Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Status field.', Comment = '%';
                }
                field("ERP Error Msg"; Rec."ERP Error Msg")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Error Msg field.', Comment = '%';
                }
            }
        }
    }
}
