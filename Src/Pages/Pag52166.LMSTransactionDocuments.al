page 52166 "12E LMS Transaction Documents"
{
    ApplicationArea = All;
    Caption = 'LMS Transaction Documents';
    CardPageId = "12E LMS Transaction Document";
    PageType = List;
    SourceTable = "12E LMS Transaction Header";
    UsageCategory = Lists;

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
                    ToolTip = 'Post the selected LMS Transaction documents.';

                    trigger OnAction()
                    var
                        LMSTransactionHeader: Record "12E LMS Transaction Header";
                        LMSTransactionPosting: Codeunit "12E LMS Transaction Posting";
                    begin
                        CurrPage.SetSelectionFilter(LMSTransactionHeader);

                        LMSTransactionPosting.Post(LMSTransactionHeader);

                        CurrPage.Update(false);
                    end;
                }

                action(PreviewPosting)
                {
                    ApplicationArea = All;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Preview the posting of the selected LMS Transaction document without posting it.';

                    trigger OnAction()
                    var
                        LMSTransactionHeader: Record "12E LMS Transaction Header";
                        LMSTransactionPosting: Codeunit "12E LMS Transaction Posting";
                    begin
                        CurrPage.SetSelectionFilter(LMSTransactionHeader);

                        LMSTransactionPosting.PreviewPosting(LMSTransactionHeader);
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
                    var
                        LMSTransactionHeader: Record "12E LMS Transaction Header";
                    begin
                        CurrPage.SetSelectionFilter(LMSTransactionHeader);
                        Rec.PerformManualRelease(LMSTransactionHeader);
                        CurrPage.Update(false);
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
                        LMSTransactionHeader: Record "12E LMS Transaction Header";
                    begin
                        CurrPage.SetSelectionFilter(LMSTransactionHeader);
                        Rec.PerformManualReopen(LMSTransactionHeader);
                        CurrPage.Update(false);
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