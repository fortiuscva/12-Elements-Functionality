page 52116 "12E CC Distribution Interface"
{
    ApplicationArea = All;
    Caption = 'Call Center Distribution Interface';
    PageType = Document;
    SourceTable = "12E CC Distribution Header";

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
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
            part(Lines; "12E CCD Interface Subform")
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
                action(GetLines)
                {
                    ApplicationArea = All;
                    Caption = 'Get Lines';
                    Image = GetLines;

                    trigger OnAction()
                    var
                        CCDMgmt: Codeunit "12E CCD Mgmt";
                    begin
                        CCDMgmt.GetLines(Rec);
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
                    actionref(GetLines_Promoted; GetLines)
                    {
                    }
                }
            }
        }
    }
}
