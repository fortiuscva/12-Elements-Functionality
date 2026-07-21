page 52140 "12E Payroll Batch Subform"
{
    ApplicationArea = All;
    Caption = 'Payroll Batch Subform';
    PageType = ListPart;
    SourceTable = "12E Payroll Batch Line";
    UsageCategory = None;
    AutoSplitKey = true;

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
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.', Comment = '%';
                }
                field("Pay Type Code"; Rec."Pay Type Code")
                {
                    ToolTip = 'Specifies the value of the Pay Type Code field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Hours Worked"; Rec."Hours Worked")
                {
                    ToolTip = 'Specifies the value of the Hours Worked field.', Comment = '%';
                }
                field("Hours Paid"; Rec."Hours Paid")
                {
                    ToolTip = 'Specifies the value of the Hours Paid field.', Comment = '%';
                }
            }
        }
    }
}
