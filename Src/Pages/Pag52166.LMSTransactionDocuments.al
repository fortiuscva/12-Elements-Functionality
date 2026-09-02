page 52166 "12E LMS Transaction Documents"
{
    ApplicationArea = All;
    Caption = 'LMS Transaction Documents';
    CardPageId = "12E LMS Transaction Document";
    PageType = List;
    SourceTable = "12E LMS Transaction Header";
    UsageCategory = Lists;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
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

                field("Error Exists"; Rec."Error Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether an error exists for the LMS Transaction document.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the LMS Transaction document.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateLMSDocument)
            {
                ApplicationArea = All;
                Caption = 'Create LMS Document';
                Image = CreateDocument;
                ToolTip = 'Create LMS Transaction documents from the available LMS transactions.';

                trigger OnAction()
                var
                    LMSTransactionCreation: Codeunit "12E LMS Creation Management";
                begin
                    LMSTransactionCreation.CreateLMSTransactions();
                    CurrPage.Update(false);
                end;
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
                    begin
                        Rec.PerformManualReopen();
                        CurrPage.Update();
                    end;
                }
            }

            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;

                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Ellipsis = true;
                    Image = Post;
                    Enabled = Rec.Status = Rec.Status::Released;
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
                    Ellipsis = true;
                    Image = ViewPostedOrder;
                    Enabled = Rec.Status = Rec.Status::Released;
                    ToolTip = 'Preview the posting of the LMS Transaction document without posting it.';

                    trigger OnAction()
                    var
                        LMSTransactionPosting: Codeunit "12E LMS Transaction Posting";
                    begin
                        LMSTransactionPosting.PreviewPosting(Rec);
                    end;
                }
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(CreateLMSDocument_Promoted; CreateLMSDocument)
                {
                }
            }

            group(Category_Category5)
            {
                Caption = 'Release';
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
                ShowAs = SplitButton;

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