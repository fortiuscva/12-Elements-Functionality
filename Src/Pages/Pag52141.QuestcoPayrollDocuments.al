page 52141 "12E Questco Payroll Documents"
{
    ApplicationArea = All;
    Caption = 'Questco Payroll Documents';
    PageType = List;
    SourceTable = "12E Payroll Batch Header";
    CardPageId = "12E Questco Payroll Document";
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
                field("Batch Status"; Rec."Batch Status")
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
            group(PayrollReleaseGroup)
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
                    Enabled = Rec."Batch Status" <> Rec."Batch Status"::Open;
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
                    Codeunit.Run(Codeunit::"12E Payroll Batch Mgmt");
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
}
