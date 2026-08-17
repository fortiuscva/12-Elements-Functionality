page 52118 "12E CCD Details"
{
    ApplicationArea = All;
    Caption = 'Contact Center Distribution Details';
    PageType = List;
    SourceTable = "12E CCD Header";
    CardPageId = "12E Call Center Distribution";
    UsageCategory = Lists;
    InsertAllowed = false;
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
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        CCDLocationMapping: Record "12E CCD Location Mapping";
                    begin
                        CCDLocationMapping.Reset();
                        CCDLocationMapping.SetRange("Location Code", Rec."Location Code");
                        Page.RunModal(Page::"12E CCD Loc. Mapping Details", CCDLocationMapping);
                    end;
                }
                field("Payroll Batch ID"; Rec."Payroll Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("No. of Hours"; Rec."No. of Hours")
                {
                    ToolTip = 'Specifies the value of the No. of Hours field.', Comment = '%';
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Period Start Date field.', Comment = '%';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ToolTip = 'Specifies the value of the Period End Date field.', Comment = '%';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                    Visible = false;
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
        area(navigation)
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
                        if Rec."Payroll Batch ID" <> 0 then
                            CCDDetailedData.SetRange("Location Code", 'PFCC')
                        else
                            CCDDetailedData.SetRange("Location Code", 'RDTJ');
                        CCDDetailedData.SetFilter("Call Date", '>=%1&<=%2', Rec."Period Start Date", Rec."Period End Date");
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
                    var
                        CCDHeader: Record "12E CCD Header";
                    begin
                        CurrPage.SetSelectionFilter(CCDHeader);
                        Rec.PerformManualRelease(CCDHeader);
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
                        CCDHeader: Record "12E CCD Header";
                    begin
                        CurrPage.SetSelectionFilter(CCDHeader);
                        Rec.PerformManualReopen(CCDHeader);
                        CurrPage.Update(false);
                    end;
                }


            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = Action;
                action(CreateCCDDocuments)
                {
                    ApplicationArea = All;
                    Caption = 'Create CCD Documents';
                    Image = Document;
                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"12E CCD Mgmt");
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
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(CreateCCDDocuments_Promoted; CreateCCDDocuments)
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