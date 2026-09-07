page 52124 "12E Lead Accruals"
{
    ApplicationArea = All;
    Caption = 'Lead Accruals';
    PageType = List;
    SourceTable = "12E Lead Accrual";
    CardPageId = "12E Lead Accrual";
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(LeadAccrualReleaseGroup)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = all;
                    Caption = 'Re&lease';
                    Enabled = Rec.Status <> Rec.Status::Released;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        LeadAccrual: Record "12E Lead Accrual";
                    begin
                        Currpage.SetSelectionFilter(LeadAccrual);
                        Rec.PerformManualRelease(LeadAccrual);
                        CurrPage.Update(false);
                    end;
                }

                action(Reopen)
                {
                    ApplicationArea = all;
                    Caption = 'Re&open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        LeadAccrual: Record "12E Lead Accrual";
                    begin
                        Currpage.SetSelectionFilter(LeadAccrual);
                        Rec.PerformManualReopen(LeadAccrual);
                        CurrPage.Update(false);
                    end;
                }
            }

            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = all;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    AboutTitle = 'Posting the order';
                    AboutText = 'Posting will ship or invoice the quantities on the order, or both. **Post** and **Send** can save the order as a file, print it, or attach it to an email, all in one go.';

                    trigger OnAction()
                    var
                        LeadAccPostMgmt: Codeunit "12E Lead Accrual Post Mgmt";
                    begin
                        CurrPage.Update(true);
                        if not Confirm(PostConfirmQst) then
                            exit;

                        LeadAccPostMgmt.RunPosting(Rec);
                    end;
                }
                action(PreviewPosting)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ShortCutKey = 'Ctrl+Alt+F9';
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        LeadAccPostMgmt: Codeunit "12E Lead Accrual Post Mgmt";
                    begin
                        CurrPage.Update(true);
                        LeadAccPostMgmt.PreviewPost(Rec);
                    end;
                }
            }
            action(CalcuateAccruals)
            {
                ApplicationArea = All;
                Caption = 'Calcuate Accruals';
                Image = GetLines;
                ToolTip = 'Fetch and prepare EPIC payment lines for this batch.';

                trigger OnAction()
                var
                    LeadAccrualMgmt: Codeunit "12E Lead Accrual Mgmt";
                begin
                    LeadAccrualMgmt.Run(Rec);
                    CurrPage.Update(false);
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';
                group(Category_Category6)
                {
                    Caption = 'Posting', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    ShowAs = SplitButton;

                    actionref(Post_Promoted; Post)
                    {
                    }
                    actionref(PreviewPosting_Promoted; PreviewPosting)
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
                group(Category_Category7)
                {
                    Caption = 'Invoice';
                    actionref(GetInvoiceData_Promoted; CalcuateAccruals)
                    {
                    }
                }
            }
        }
    }
    var
        PostConfirmQst: Label 'Do you want to post the lead accrual journal lines for this document?';
        PostedMsg: Label 'The lead accrual document has been posted.';
}
