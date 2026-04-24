page 52107 "12E EPIC Payments Batch List"
{
    ApplicationArea = All;
    Caption = 'EPIC Payments Batch List';
    PageType = List;
    SourceTable = "12E EPIC Payments Batch Header";
    CardPageId = "12E EPIC Payments Batch";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Batch No."; Rec."Batch No.")
                {
                    ToolTip = 'Specifies the value of the Batch No. field.', Comment = '%';
                }
                field("Batch Date"; Rec."Batch Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(EPICPayBatchReleaseGroup)
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
                        EPICPayBatchHeader: Record "12E EPIC Payments Batch Header";
                    begin
                        Currpage.SetSelectionFilter(EPICPayBatchHeader);
                        Rec.PerformManualRelease(EPICPayBatchHeader);
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
                        EPICPayBatchHeader: Record "12E EPIC Payments Batch Header";
                    begin
                        Currpage.SetSelectionFilter(EPICPayBatchHeader);
                        Rec.PerformManualReopen(EPICPayBatchHeader);
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
                    begin

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
                    begin
                        // ShowPreview();
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

}
