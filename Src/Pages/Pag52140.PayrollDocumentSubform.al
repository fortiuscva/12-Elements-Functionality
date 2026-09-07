page 52140 "12E Payroll Document Subform"
{
    ApplicationArea = All;
    Caption = 'Payroll Document Subform';
    PageType = ListPart;
    SourceTable = "12E Payroll Batch Line";
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
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    Visible = false;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Account No. field.', Comment = '%';
                }
                field("Pay Type Code"; Rec."Pay Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Type Code field.', Comment = '%';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                }
                field("Hours Worked"; Rec."Hours Worked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Hours Worked field.', Comment = '%';
                    Visible = false;
                }
                field("Hours Paid"; Rec."Hours Units Paid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Hours Paid field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
}
