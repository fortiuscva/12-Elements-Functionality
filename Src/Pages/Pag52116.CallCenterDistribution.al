page 52116 "12E Call Center Distribution"
{
    ApplicationArea = All;
    Caption = 'Contact Center Distribution';
    PageType = Document;
    SourceTable = "12E CCD Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Payroll Batch ID"; Rec."Payroll Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Period Start Date field.', Comment = '%';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ToolTip = 'Specifies the value of the Period End Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Editable = false;
                }
            }
            part(Lines; "12E CCD Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(CCDReleaseGroup)
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
                        ReleaseCCDDoc: Codeunit "12E CCD Release Mgmt";
                    begin
                        ReleaseCCDDoc.PerformManualReopen(Rec);
                        CurrPage.Update();
                    end;
                }


                action(ShowAllocationDetails)
                {
                    ApplicationArea = All;
                    Caption = 'Show Allocation Details';
                    Image = ViewDetails;

                    RunObject = Page "12E CCD Allocation Details";
                    RunPageLink = "CCD No." = FIELD("No.");
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(PostandCreateInvoices)
                {
                    ApplicationArea = All;
                    Caption = 'Post and Create Invoices';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Post the contact center distribution document and creates sales invoices.';

                    trigger OnAction()
                    var
                        CCDInvoiceMgmt: Codeunit "12E CCD Invoice Mgmt";
                    begin
                        CCDInvoiceMgmt.PostandCreateInvoices(Rec);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
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

                    actionref(ShowAllocation_Promoted; ShowAllocationDetails)
                    {
                    }
                }
                group(Category_Category6)
                {
                    Caption = 'Posting', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    ShowAs = SplitButton;
                    actionref(PostandCreateInvoices_Promoted; PostandCreateInvoices)
                    {
                    }
                }
            }
        }
    }
}
