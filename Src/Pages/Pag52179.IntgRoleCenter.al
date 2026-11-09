page 52179 "12E Intg. RoleCenter"
{
    ApplicationArea = All;
    Caption = '12E Integration Role Center';
    PageType = CardPart;
    SourceTable = "12E Intg. RoleCenter";

    layout
    {
        area(Content)
        {
            cuegroup(ContactCenterDistribution)
            {
                Caption = 'ContactCenterDistribution';

                field("CCD Documents"; Rec."CCD Documents")
                {
                    DrillDownPageId = "12E CCD Details";
                    ToolTip = 'Specifies the value of the CCD Documents field.', Comment = '%';
                }
                field("Posted CCD Documents"; Rec."Posted CCD Documents")
                {
                    DrillDownPageId = "12E Posted CCD Details";
                    ToolTip = 'Specifies the value of the Posted CCD Documents field.', Comment = '%';
                }
            }
            cuegroup(Payroll)
            {
                Caption = 'Payroll';
                field("Payroll Documents"; Rec."Payroll Documents")
                {
                    DrillDownPageId = "12E Questco Payroll Documents";
                    ToolTip = 'Specifies the value of the Payroll Documents field.', Comment = '%';
                }
                field("Posted Payroll Documents"; Rec."Posted Payroll Documents")
                {
                    DrillDownPageId = "12E Posted Payroll Documents";
                    ToolTip = 'Specifies the value of the Posted Payroll Documents field.', Comment = '%';
                }
            }
            cuegroup(LMTransactions)
            {
                Caption = 'LMS Transactions';
                field("LMS Transaction Documents"; Rec."LMS Transaction Documents")
                {
                    DrillDownPageId = "12E LMS Transaction Documents";
                    ToolTip = 'Specifies the value of the LMS Transaction Documents field.', Comment = '%';
                }
                field("Posted LMS Transc Documents"; Rec."Posted LMS Transc Documents")
                {
                    DrillDownPageId = "12E Posted LMS Trans.Documents";
                    ToolTip = 'Specifies the value of the Posted LMS Transaction Documents field.', Comment = '%';
                }
            }
            cuegroup(LoyaltyPoints)
            {
                Caption = 'Loyalty Points';
                field("Loyalty Points Documents"; Rec."Loyalty Points")
                {
                    ToolTip = 'Specifies the value of the LMS Transaction Documents field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        LoyaltyPoints: Record "12E Loyalty Points";
                    begin
                        LoyaltyPoints.SetRange("G/L Register No.", 0);
                        Page.Run(Page::"12E Loyalty Points", LoyaltyPoints);
                    end;
                }
                field("Posted Loyalty Documents"; Rec."Posted Loyalty Points")
                {
                    ToolTip = 'Specifies the value of the Posted LMS Transaction Documents field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        LoyaltyPoints: Record "12E Loyalty Points";
                    begin
                        LoyaltyPoints.SetFilter("G/L Register No.", '<>%1', 0);
                        Page.Run(Page::"12E Loyalty Points", LoyaltyPoints);
                    end;
                }
            }
            cuegroup(LMSBatches)
            {
                Caption = 'LMS Batches';
                field("LMS Batches"; Rec."LMS Batches")
                {
                    ToolTip = 'Specifies the value of the LMS Batches field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        LMSBatch: Record "12E LMS Batch";
                    begin
                        LMSBatch.SetRange("G/L Register No.", 0);
                        Page.Run(Page::"12E LMS Batches", LMSBatch);
                    end;
                }

                field("Posted LMS Batches"; Rec."Posted LMS Batches")
                {
                    ToolTip = 'Specifies the value of the Posted LMS Batches field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        LMSBatch: Record "12E LMS Batch";
                    begin
                        LMSBatch.SetFilter("G/L Register No.", '<>%1', 0);
                        Page.Run(Page::"12E LMS Batches", LMSBatch);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get('12E Intg. RoleCenter') then begin
            Rec.Init();
            Rec."Primary Key" := '12E Intg. RoleCenter';
            Rec.Insert();
        end;

        Rec.CalcFields("CCD Documents", "Posted CCD Documents", "LMS Transaction Documents", "Posted LMS Transc Documents", "Payroll Documents", "Posted Payroll Documents", "Loyalty Points", "Posted Loyalty Points", "LMS Batches", "Posted LMS Batches");
    end;
}
