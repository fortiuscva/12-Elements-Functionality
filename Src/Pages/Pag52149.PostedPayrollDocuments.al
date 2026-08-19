page 52149 "12E Posted Payroll Documents"
{
    ApplicationArea = All;
    Caption = 'Posted Payroll Documents';
    PageType = List;
    SourceTable = "12E Posted Payroll Header";
    CardPageId = "12E Posted Payroll Document";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Specifies the value of the Client ID field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    ToolTip = 'Specifies the value of the Pay Date field.', Comment = '%';
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period Start Date field.', Comment = '%';
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period End Date field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field(Status; Rec."Status")
                {
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ShowGLEntries)
            {
                ApplicationArea = All;
                Caption = 'Show G/L Entries';
                Ellipsis = true;
                Image = LedgerEntries;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.Reset();
                    GLEntry.SetRange("Document No.", Rec."No.");
                    GLEntry.SetRange("Posting Date", Rec."Pay Date");
                    Page.RunModal(Page::"General Ledger Entries", GLEntry);
                end;
            }
            group(Reverse)
            {
                Caption = 'Reverse';
                Image = ReverseRegister;

                action(ReverseRegister)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reverse Register';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    ToolTip = 'Reverses the payroll register and creates a new Payroll Document.';
                    Enabled = not Rec.Reversed;

                    trigger OnAction()
                    var
                        PayrollReverseMgt: Codeunit "12E Payroll Reverse Mgt.";
                    begin
                        PayrollReverseMgt.ReversePayroll(Rec);
                        CurrPage.Update();
                    end;
                }
            }
        }
        area(Navigation)
        {
            group(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;

                action("Show Payroll Batch")
                {
                    ApplicationArea = All;
                    Caption = 'Show Payroll Batch';
                    Image = Entries;
                    ToolTip = 'Shows the Payroll Batch related to this Payroll Document.';

                    trigger OnAction()
                    var
                        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
                    begin
                        QuestcoPayrollBatch.Reset();
                        QuestcoPayrollBatch.SetRange("Client ID", Rec."Client ID");
                        QuestcoPayrollBatch.SetRange("Pay Period Start Date", Rec."Pay Period Start Date");
                        QuestcoPayrollBatch.SetRange("Pay Period End Date", Rec."Pay Period End Date");
                        Page.Run(Page::"12E QPAY Batches", QuestcoPayrollBatch);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ShowGLEntries_Promoted; ShowGLEntries)
                {

                }
                actionref(ReverseRegister_Promoted; ReverseRegister)
                { }
            }
            group(Category_Category5)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 4.';
                ShowAs = Standard;
                actionref(ShowPayrollBatch_Promoted; "Show Payroll Batch")
                {
                }
            }
        }
    }
}
