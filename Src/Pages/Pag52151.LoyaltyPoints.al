page 52151 "12E Loyalty Points"
{
    ApplicationArea = All;
    Caption = 'Loyalty Points';
    PageType = List;
    SourceTable = "12E Loyalty Points";
    SourceTableView = sorting("PK ID") order(descending);
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PK ID"; Rec."PK ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field(Store; Rec."Store Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store field.', Comment = '%';
                }
                field("Month End Date"; Rec."Month End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Month End Date field.', Comment = '%';
                }
                field("Points Earned"; Rec."Points Earned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Points Earned field.', Comment = '%';
                }
                field("Points Expired"; Rec."Points Expired")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Points Expired field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
                field("Posting Error"; Rec."Posting Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Error field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                }
                field(ERPStatus; Rec.ERPStatus)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERPStatus field.', Comment = '%';
                }
                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERPErrorMsg field.', Comment = '%';
                }
                field("Export Batch ID"; Rec."Export Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Export Batch ID field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Post the Loyalty Point entry.';

                trigger OnAction()
                var
                    LoyaltyPosting: Codeunit "12E Loyalty Posting";
                begin
                    if not Confirm('Do you want to post the Loyalty %1?', false, Rec."PK ID") then
                        exit;

                    LoyaltyPosting.Post(Rec);
                    Rec.Get(Rec."PK ID");

                    if Rec.Processed then
                        Message('Loyalty Point(s) posted successfully.');

                    CurrPage.Update(false);
                end;
            }

            action(PreviewPosting)
            {
                ApplicationArea = All;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Ctrl+Alt+F9';
                ToolTip = 'Preview the General Ledger Entries that will be created.';

                trigger OnAction()
                var
                    LoyaltyPosting: Codeunit "12E Loyalty Posting";
                begin
                    LoyaltyPosting.PreviewPosting(Rec);
                end;
            }

            action(PostBatch)
            {
                ApplicationArea = All;
                Caption = 'Post Batch';
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Post the Loyalty Point entries based on the selected filters.';

                trigger OnAction()
                var
                    LoyaltyPoints: Record "12E Loyalty Points";
                begin
                    LoyaltyPoints.CopyFilters(Rec);
                    Report.RunModal(Report::"12E Loyalty Posting", true, false, LoyaltyPoints);
                    CurrPage.Update(false);
                end;
            }

            action(ReverseRegister)
            {
                ApplicationArea = All;
                Caption = 'Reverse Register';
                Ellipsis = true;
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Reverse the Loyalty Point register.';
                Enabled = not Rec.Reversed;

                trigger OnAction()
                var
                    LoyaltyReverseMgt: Codeunit "12E Loyalty Reverse Mgt.";
                begin
                    if not Confirm(ConfirmReverseRegisterQst) then
                        exit;
                    LoyaltyReverseMgt.ReverseLoyalty(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter(Portfolio, '<>%1', '');
        if not CompanyMapping.FindFirst() then
            Error('%1 is not mapped to any portfolio in 12 elements setup.', CompanyName());

        Rec.FilterGroup(10);
        Rec.SetRange(Portfolio, CompanyMapping.Portfolio);
        Rec.FilterGroup(0);
    end;

    var
        ConfirmReverseRegisterQst: Label 'Do you want to reverse the G/L register associated with this Loyalty Points?';
}