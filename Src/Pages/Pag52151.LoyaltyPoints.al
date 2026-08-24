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
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field(Store; Rec."Store Name")
                {
                    ToolTip = 'Specifies the value of the Store field.', Comment = '%';
                }
                field("Month End Date"; Rec."Month End Date")
                {
                    ToolTip = 'Specifies the value of the Month End Date field.', Comment = '%';
                }
                field("Points Earned"; Rec."Points Earned")
                {
                    ToolTip = 'Specifies the value of the Points Earned field.', Comment = '%';
                }
                field("Points Expired"; Rec."Points Expired")
                {
                    ToolTip = 'Specifies the value of the Points Expired field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
                field("Posting Error"; Rec."Posting Error")
                {
                    ToolTip = 'Specifies the value of the Posting Error field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                }
                field(ERPStatus; Rec.ERPStatus)
                {
                    ToolTip = 'Specifies the value of the ERPStatus field.', Comment = '%';
                }
                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ToolTip = 'Specifies the value of the ERPErrorMsg field.', Comment = '%';
                }
                field("Export Batch ID"; Rec."Export Batch ID")
                {
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
                ApplicationArea = all;
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
                    CurrPage.Update(false);
                end;
            }

            action(PreviewPosting)
            {
                ApplicationArea = all;
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
                ApplicationArea = all;
                Caption = 'Post Batch';
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Post the Loyalty Point entries based on the selected filters.';

                trigger OnAction()
                var
                    LoyaltyPoints: Record "12E Loyalty Points";
                begin
                    LoyaltyPoints.Reset();
                    LoyaltyPoints.SetRange("PK ID", Rec."PK ID");
                    if LoyaltyPoints.FindFirst() then
                        Report.RunModal(Report::"12E Loyalty Posting", true, false, LoyaltyPoints);
                    CurrPage.Update(false);
                end;
            }
            action(ReverseRegister)
            {
                ApplicationArea = all;
                Caption = 'Reverse Register';
                Ellipsis = true;
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Reverses the payroll register and creates a new Payroll Document.';
                Enabled = not Rec.Reversed;

                trigger OnAction()
                var
                    LoyaltyReverseMgt: Codeunit "12E Loyalty Reverse Mgt.";
                begin
                    LoyaltyReverseMgt.ReverseLoyalty(Rec);
                    CurrPage.Update();
                end;
            }
        }

    }
    trigger OnOpenPage()
    var
        CompanyInformation: Record "Company Information";
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyInformation.Get();
        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyInformation.Name);
        if CompanyMapping.FindFirst() then
            Rec.SetRange(Portfolio, CompanyMapping.Portfolio);
    end;
}
