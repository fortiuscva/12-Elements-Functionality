page 52164 "12E LMS Transaction Document"
{
    ApplicationArea = All;
    Caption = 'LMS Transaction Document';
    PageType = Document;
    SourceTable = "12E LMS Transaction Header";
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
                    ToolTip = 'Specifies the value of the No. field.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }

                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Datasource ID field.';
                }

                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }

                field("Error Exists"; Rec."Error Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether an error exists for the LMS Transaction document.';
                }
            }

            part(Lines; "12E LMS Transaction Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Posting)
            {
                Caption = 'Posting';
                Image = Post;

                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Image = Post;
                    ShortCutKey = 'F9';
                    ToolTip = 'Post the LMS Transaction document.';

                    trigger OnAction()
                    var
                        LMSTransactionPosting: Codeunit "12E LMS Transaction Posting";
                    begin
                        LMSTransactionPosting.Post(Rec);
                        CurrPage.Update(false);
                    end;
                }

                action(PreviewPosting)
                {
                    ApplicationArea = All;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Preview the posting of the LMS Transaction document without posting it.';

                    trigger OnAction()
                    var
                        LMSTransactionPosting: Codeunit "12E LMS Transaction Posting";
                    begin
                        LMSTransactionPosting.PreviewPosting(Rec);
                    end;
                }
            }

            group(LMSReleaseGroup)
            {
                Caption = 'Release';
                Image = ReleaseDoc;

                action(Release)
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                    Caption = 'Re&open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been released.';

                    trigger OnAction()
                    var
                        ReleaseLMSDoc: Codeunit "12E LMS Release Mgt.";
                    begin
                        ReleaseLMSDoc.PerformManualReopen(Rec);
                        CurrPage.Update();
                    end;
                }
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
            }

            group(Category_Category6)
            {
                Caption = 'Posting';

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