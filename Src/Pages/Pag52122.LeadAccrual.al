page 52122 "12E Lead Accrual"
{
    ApplicationArea = All;
    Caption = 'Lead Accrual';
    PageType = Document;
    SourceTable = "12E Lead Accrual";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                group(DocumentDetails)
                {
                    Caption = 'Document Details';

                    field("No."; Rec."No.")
                    {
                        ToolTip = 'Specifies the value of the No. field.';

                        trigger OnAssistEdit()
                        begin
                            if Rec.AssistEdit(xRec) then
                                CurrPage.Update();
                        end;
                    }

                    field(Status; Rec.Status)
                    {
                        ToolTip = 'Specifies the status of the lead accrual document.';
                    }

                    field(SystemCreatedAt; Rec.SystemCreatedAt)
                    {
                        Caption = 'Created At';
                        Editable = false;
                        ToolTip = 'Specifies when the document was created.';
                    }

                    field(CreatedBy; CreatedBy)
                    {
                        Caption = 'Created By';
                        Editable = false;
                        ToolTip = 'Specifies who created the document.';
                    }
                }

                group(AccrualPeriod)
                {
                    Caption = 'Accrual Period';

                    field(Year; Rec.Year)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the year for the accrual period.';
                    }

                    field(Month; Rec.Month)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the month for the accrual period.';
                    }

                    field("From Date"; Rec."From Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the start date of the accrual period.';
                    }

                    field("To Date"; Rec."To Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the end date of the accrual period.';
                    }
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
                        ToolTip = 'Specifies the value of the Posting Error field.';
                    }
                }
            }

            part(Lines; "12E Lead Accrual Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Lead Accrual No." = field("No.");
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
                    begin
                        Rec.PerformManualRelease();
                        CurrPage.Update();
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
                        ReleaseLeadAccrualDoc: Codeunit "12E Lead Accrual Release Mgmt";
                    begin
                        ReleaseLeadAccrualDoc.PerformManualReopen(Rec);
                        CurrPage.Update();
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

                        LeadAccPostMgmt.Run(Rec);
                        Message(PostedMsg);
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
        PostConfirmQst: Label 'Do you want to post the lead accrual journal lines for this document?';
        PostedMsg: Label 'The lead accrual document has been posted.';
}