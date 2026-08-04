page 52118 "12E CCD Details"
{
    ApplicationArea = All;
    Caption = 'Contact Center Time Distribution Details';
    PageType = List;
    SourceTable = "12E CCD Header";
    CardPageId = "12E Call Center Distribution";
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
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                // field("Start Date"; Rec."Start Date")
                // {
                //     ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                // }
                // field("End Date"; Rec."End Date")
                // {
                //     ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                // }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
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
                action(CalculateAlloCation)
                {
                    ApplicationArea = All;
                    Caption = 'Calculate Allocation';
                    Image = GetLines;

                    trigger OnAction()
                    var
                        CCDMgmt: Codeunit "12E CCD Mgmt";
                    begin
                        CCDMgmt.Run();
                        CurrPage.Update();
                    end;
                }
                action(CreateCCDDocuments)
                {
                    ApplicationArea = All;
                    Caption = 'Create CCD Documents';
                    Image = Create;

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"12E CCD Mgmt");
                        CurrPage.Update();
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
                    actionref(CreateCCDDocuments_Promoted; CreateCCDDocuments)
                    {
                    }
                }
            }
        }
    }
}
