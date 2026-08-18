page 52147 "12E Posted Payroll Document"
{
    ApplicationArea = All;
    Caption = 'Posted Payroll Document';
    PageType = Document;
    SourceTable = "12E Posted Payroll Header";
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client ID field.', Comment = '%';
                }
                group(Batch)
                {
                    Caption = 'Batch';
                    field("Batch ID"; Rec."Batch ID")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                    }
                    field("Batch Type"; Rec."Batch Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                    }
                }
                group(Period)
                {
                    field("Pay Date"; Rec."Pay Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Pay Date field.', Comment = '%';
                    }
                    field("Pay Period Start Date"; Rec."Pay Period Start Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Pay Period Start Date field.', Comment = '%';
                    }
                    field("Pay Period End Date"; Rec."Pay Period End Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Pay Period End Date field.', Comment = '%';
                    }
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
                }
                field("Created By"; CreatedBy)
                {
                    Caption = 'Created By';
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            part(Lines; "12E Posted Payroll Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
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
    trigger OnOpenPage()
    var
        UserRec: Record User;
    begin
        Clear(CreatedBy);
        CreatedBy := '';
        UserRec.Reset();
        if UserRec.Get(Rec.SystemCreatedBy) then
            CreatedBy := UserRec."User Name";
    end;

    var
        CreatedBy: Code[50];
}
