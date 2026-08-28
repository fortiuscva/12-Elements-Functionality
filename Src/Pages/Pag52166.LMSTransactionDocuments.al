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
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field("Error Exists"; Rec."Error Exists")
                {
                    ToolTip = 'Specifies the value of the Error Exists field.', Comment = '%';
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
            group(LMSReleaseGroup)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = all;
                    Caption = 'Re&lease';
                    Enabled = Rec."Status" <> Rec."Status"::Released;
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
                    ApplicationArea = all;
                    Caption = 'Re&open';
                    Enabled = Rec."Status" <> Rec."Status"::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
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
        }
    }
}
