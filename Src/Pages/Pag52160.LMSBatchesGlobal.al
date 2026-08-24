page 52160 "12E LMS Batches (Global)"
{
    ApplicationArea = All;
    Caption = 'LMS Batches (Global)';
    PageType = List;
    SourceTable = "12E LMS Batch";
    UsageCategory = Lists;
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
                field("PK ID"; Rec."PK ID")
                {
                    ApplicationArea = All;
                }

                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                }

                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                }

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                }

                field(Processor; Rec.Processor)
                {
                    ApplicationArea = All;
                }

                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }

                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }

                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                }

                field("Credit Account No."; Rec."Credit Account No.")
                {
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }

                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                }

                field(ERPStatus; Rec.ERPStatus)
                {
                    ApplicationArea = All;
                }

                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ApplicationArea = All;
                }

                field("Export Batch ID"; Rec."Export Batch ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}