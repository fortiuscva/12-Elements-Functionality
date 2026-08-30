page 52141 "12E Questco Payroll Documents"
{
    ApplicationArea = All;
    Caption = 'Payroll Documents';
    PageType = List;
    SourceTable = "12E Payroll Batch Header";
    CardPageId = "12E Questco Payroll Document";
    UsageCategory = Lists;
    InsertAllowed = false;
    Editable = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Date field.', Comment = '%';
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(PayrollReleaseGroup)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = all;
                    Caption = 'Re&lease';
                    Enabled = Rec."Status" <> Rec."Status"::Released;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        PayrollHeader: Record "12E Payroll Batch Header";
                    begin
                        Currpage.SetSelectionFilter(PayrollHeader);
                        Rec.PerformManualRelease(PayrollHeader);
                        CurrPage.Update(false);
                    end;
                }

                action(Reopen)
                {
                    ApplicationArea = all;
                    Caption = 'Re&open';
                    Enabled = Rec."Status" <> Rec."Status"::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        PayrollHeader: Record "12E Payroll Batch Header";
                    begin
                        Currpage.SetSelectionFilter(PayrollHeader);
                        Rec.PerformManualReopen(PayrollHeader);
                        CurrPage.Update(false);
                    end;
                }
            }
            action(CreatePayrollDocuments)
            {
                ApplicationArea = All;
                Caption = 'Create Payroll Documents';
                Image = CreateDocument;

                trigger OnAction()
                begin
                    if not Confirm(ConfirmCreateQst) then
                        exit;
                    Codeunit.Run(Codeunit::"12E Payroll Batch Mgmt");
                end;
            }
            group(Posting)
            {
                Caption = 'Posting';
                Image = Post;

                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Image = Post;

                    Enabled = Rec."Status" = Rec."Status"::Released;

                    trigger OnAction()
                    var
                        PayrollBatchPost: Codeunit "12E Payroll Batch Post";
                    begin
                        if not Confirm(ConfirmPostQst) then
                            exit;
                        PayrollBatchPost.Post(Rec);
                    end;
                }

                action(PreviewPosting)
                {
                    ApplicationArea = All;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;

                    Enabled = Rec."Status" = Rec."Status"::Released;

                    trigger OnAction()
                    var
                        PayrollBatchPost: Codeunit "12E Payroll Batch Post";
                    begin
                        PayrollBatchPost.PreviewPosting(Rec);
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
                        QuestcoPayrollBatch.FilterGroup := 8;
                        QuestcoPayrollBatch.SetRange("Batch ID", Rec."Batch ID");
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

                Caption = 'Process';
                actionref(CreatePayrollDocuments_Promoted; CreatePayrollDocuments)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Release', Comment = 'Generated from the PromotedActionCategories property index 4.';
                ShowAs = SplitButton;

                actionref(Release_Promoted; Release)
                {
                }
                actionref(Reopen_Promoted; Reopen)
                {
                }
            }

            group(Category_Posting)
            {
                Caption = 'Posting';
                ShowAs = SplitButton;

                actionref(Post_Promoted; Post)
                {
                }

                actionref(PreviewPosting_Promoted; PreviewPosting)
                {
                }
            }
            group(Category_Category7)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 5.';
                ShowAs = Standard;
                actionref(ShowPayrollBatch_Promoted; "Show Payroll Batch")
                {
                }
            }
        }
    }
    var
        ConfirmCreateQst: Label 'Do you want to create payroll documents?';
        ConfirmPostQst: Label 'Do you want to post the payroll documents?';
}
