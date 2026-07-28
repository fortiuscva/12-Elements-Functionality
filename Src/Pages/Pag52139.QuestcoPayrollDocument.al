page 52139 "12E Questco Payroll Document"
{
    ApplicationArea = All;
    Caption = 'Questco Payroll Document';
    PageType = Document;
    SourceTable = "12E Payroll Batch Header";
    UsageCategory = None;

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
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
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
                field("Batch Status"; Rec."Batch Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
                }
                field("Created By"; CreatedBy)
                {
                    Caption = 'Created By';
                    ApplicationArea = All;
                }
            }
            part(Lines; "12E Payroll Document Subform")
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
            group(PayrollBatchReleaseGroup)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = all;
                    Caption = 'Re&lease';
                    Enabled = Rec."Batch Status" <> Rec."Batch Status"::Released;
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
                    Enabled = Rec."Batch Status" <> Rec."Batch Status"::Open;
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
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;

                Enabled = Rec."Batch Status" = Rec."Batch Status"::Released;

                trigger OnAction()
                var
                    PayrollBatchPost: Codeunit "12E Payroll Batch Post";
                begin
                    PayrollBatchPost.Post(Rec);
                    CurrPage.Update();
                end;
            }

            action(PreviewPosting)
            {
                ApplicationArea = All;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;

                Enabled = Rec."Batch Status" = Rec."Batch Status"::Released;

                trigger OnAction()
                var
                    PayrollBatchPost: Codeunit "12E Payroll Batch Post";
                begin
                    PayrollBatchPost.PreviewPosting(Rec);
                end;
            }
        }
        area(Promoted)
        {
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
                actionref(CreatePayrollDocuments_Promoted; CreatePayrollDocuments)
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
                actionref(PreviewPosting_Promoted; PreviewPosting)
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
