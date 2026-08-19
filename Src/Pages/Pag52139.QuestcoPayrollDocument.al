page 52139 "12E Questco Payroll Document"
{
    ApplicationArea = All;
    Caption = 'Payroll Document';
    PageType = Document;
    SourceTable = "12E Payroll Batch Header";
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

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
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }

                field("Client ID"; Rec."Client ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                group(Batch)
                {
                    Caption = 'Batch';

                    field("Batch ID"; Rec."Batch ID")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }

                    field("Batch Type"; Rec."Batch Type")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }

                group(Period)
                {
                    Caption = 'Period';

                    field("Pay Date"; Rec."Pay Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }

                    field("Pay Period Start Date"; Rec."Pay Period Start Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }

                    field("Pay Period End Date"; Rec."Pay Period End Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(Amount; Rec.Amount)
                    {
                        ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                        Editable = false;
                    }
                }

                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created By"; CreatedBy)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                group(PostingError)
                {
                    Caption = 'Posting Error';
                    field("Posting Error"; Rec."Posting Error")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Posting Error field.', Comment = '%';
                    }
                }
            }
            part(Lines; "12E Payroll Document Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Editable = false;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(PayrollBatchReleaseGroup)
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
                    begin
                        Rec.PerformManualRelease();
                        CurrPage.Update();
                    end;
                }

                action(Reopen)
                {
                    ApplicationArea = all;
                    Caption = 'Re&open';
                    Enabled = Rec."Status" <> Rec."Status"::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released "Batch Status" and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        ReleasePayrollDoc: Codeunit "12E Payroll Release Mgmt";
                    begin
                        ReleasePayrollDoc.PerformManualReopen(Rec);
                        CurrPage.Update();
                    end;
                }
            }
            action(CreatePayrollDocuments)
            {
                ApplicationArea = All;
                Caption = 'Create Payroll Documents';
                Image = CreateDocument;

                trigger OnAction()
                var
                    PayrollBatchMgmt: Codeunit "12E Payroll Batch Mgmt";
                begin
                    PayrollBatchMgmt.CreatePayrollDocuments(Rec);
                    CurrPage.Update();
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
