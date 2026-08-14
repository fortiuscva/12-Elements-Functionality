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
                    Editable = false;

                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                    Editable = false;

                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Period Start Date field.', Comment = '%';
                    Editable = false;

                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ToolTip = 'Specifies the value of the Period End Date field.', Comment = '%';
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field("No. of Hours"; Rec."No. of Hours")
                {
                    ToolTip = 'Specifies the value of the No. of Hours field.', Comment = '%';
                    Editable = false;
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
                Editable = false;
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
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Post the contact center distribution document.';

                    trigger OnAction()
                    var
                        CCDInvoiceMgmt: Codeunit "12E CCD Post";
                    begin
                        CCDInvoiceMgmt.Post(Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(Navigation)
        {
            group(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;

                action("Show Contact Center Detailed Data")
                {
                    ApplicationArea = All;
                    Caption = 'Show Contact Center Detailed Data';
                    Image = Entries;
                    ToolTip = 'Shows the Contact Center Detailed Data related to this CCD document.';

                    trigger OnAction()
                    var
                        CCDDetailedData: Record "12E CCD Detailed Data";
                    begin
                        CCDDetailedData.Reset();
                        CCDDetailedData.SetRange("Location Code", Rec."Location Code");
                        CCDDetailedData.SetRange("Call Date", Rec."Period Start Date", Rec."Period End Date");
                        Page.Run(Page::"12E CCD Data", CCDDetailedData);
                    end;
                }

                action("Show Payroll Batch")
                {
                    ApplicationArea = All;
                    Caption = 'Show Payroll Batch';
                    Image = Entries;
                    ToolTip = 'Shows the Payroll Batch related to this CCD document.';

                    trigger OnAction()
                    var
                        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
                    begin
                        QuestcoPayrollBatch.Reset();
                        QuestcoPayrollBatch.SetRange("Batch ID", Rec."Payroll Batch ID");
                        Page.Run(Page::"12E QPAY Batches", QuestcoPayrollBatch);
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
                }
                group(Category_Category6)
                {
                    Caption = 'Posting', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    ShowAs = SplitButton;
                    actionref(Post_Promoted; Post)
                    {
                    }
                }
                group(Category_Category7)
                {
                    Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    ShowAs = Standard;
                    actionref(ShowContactCenterDetailedData_Promoted; "Show Contact Center Detailed Data")
                    {
                    }
                    actionref(ShowPayrollBatch_Promoted; "Show Payroll Batch")
                    {
                    }
                }
            }
        }
    }
}
