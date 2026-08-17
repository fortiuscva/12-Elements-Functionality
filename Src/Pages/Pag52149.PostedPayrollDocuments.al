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
                field(Status; Rec."Status")
                {
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
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
                        Page.Run(Page::"12E Questco Payroll Batches", QuestcoPayrollBatch);
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
