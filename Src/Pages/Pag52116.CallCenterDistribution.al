page 52116 "12E Call Center Distribution"
{
    ApplicationArea = All;
    Caption = 'Contact Center Time Distribution';
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
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
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

                action(CreateInvoices)
                {
                    ApplicationArea = All;
                    Caption = 'Create Invoices';
                    Image = CreateDocument;

                    trigger OnAction()
                    var
                        CCDInvoiceMgmt: Codeunit "12E CCD Invoice Mgmt";
                    begin
                        CCDInvoiceMgmt.CreateInvoices(Rec);
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
                    actionref(CreateInvoices_Promoted; CreateInvoices)
                    {
                    }
                    actionref(ShowAllocation_Promoted; ShowAllocationDetails)
                    {
                    }
                }
            }
        }
    }
}
