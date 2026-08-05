page 52104 "12E Setup"
{
    ApplicationArea = All;
    Caption = 'Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "12E Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Balancing G/L Account"; Rec."Balancing G/L Account")
                {
                    ToolTip = 'Specifies the value of the EPIC Balancing G/L Account field.', Comment = '%';
                }
                field("Lead Accrual Jnl. Template"; Rec."Lead Accrual Jnl. Template")
                {
                    ApplicationArea = all;
                }
                field("Lead Accrual Jnl. Batch"; Rec."Lead Accrual Jnl. Batch")
                {
                    ApplicationArea = all;
                }
                field("Payroll Jnl. Template"; Rec."Payroll Jnl. Template")
                {
                    ToolTip = 'Specifies the value of the Payroll Journal Template field.', Comment = '%';
                }
                field("Payroll Jnl. Batch"; Rec."Payroll Jnl. Batch")
                {
                    ToolTip = 'Specifies the value of the Payroll Journal Batch field.', Comment = '%';
                }
                field("CCD G/L Account No."; Rec."CCD G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the CCD G/L Account No. field.', Comment = '%';
                }
                field("Payroll Offset Account No."; Rec."Payroll Offset Account No.")
                {
                    ToolTip = 'Specifies the value of the Payroll Offset Account No. field.', Comment = '%';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("EPIC Payment Batch Nos."; Rec."EPIC Payment Batch Nos.")
                {
                    ToolTip = 'Specifies the value of the EPIC Payment Batch Nos. field.', Comment = '%';
                }
                field("CCD Nos."; Rec."CCD Nos.")
                {
                    ToolTip = 'Specifies the value of the Call Center Distribution Nos. field.', Comment = '%';
                }
                field("Lead Accrual Nos."; Rec."Lead Accrual Nos.")
                {
                    ToolTip = 'Specifies the value of the Lead Accrual Nos. field.', Comment = '%';
                }
                field("Payroll Batch Nos."; Rec."Payroll Batch Nos.")
                {
                    ToolTip = 'Specifies the value of the Payroll Batch Nos. field.', Comment = '%';
                }
                field("Loyalty Document Nos."; Rec."Loyalty Document Nos.")
                {
                    ToolTip = 'Specifies the value of the Loyalty Document Nos. field.', Comment = '%';
                }
            }
            group(LoyaltyPoints)
            {
                Caption = 'Loyalty Points';
                field("Loyalty Points Earned"; Rec."Loyalty Points Earned")
                {
                    ToolTip = 'Specifies the value of the EPIC Payment Batch Nos. field.', Comment = '%';
                }
                field("Deferred Rev Loyalty Pts"; Rec."Deferred Rev Loyalty Pts")
                {
                    ToolTip = 'Specifies the value of the EPIC Payment Batch Nos. field.', Comment = '%';
                }
                field("Provision for Loyalty Points"; Rec."Provision for Loyalty Points")
                {
                    ToolTip = 'Specifies the value of the Provision for Loyalty Points field.', Comment = '%';
                }
                field("Loyalty Points Reserve"; Rec."Loyalty Points Reserve")
                {
                    ToolTip = 'Specifies the value of the Loyalty Points Reserve field.', Comment = '%';
                }
                field("Loyalty Source Code"; Rec."Loyalty Source Code")
                {
                    ToolTip = 'Specifies the value of the Loyalty Source Code field.', Comment = '%';
                }
                field("Loyalty Reason Code"; Rec."Loyalty Reason Code")
                {
                    ToolTip = 'Specifies the value of the Loyalty Reason Code field.', Comment = '%';
                }
                field("Loyalty Pts. Provision %"; Rec."Loyalty Pts. Provision %")
                {
                    ToolTip = 'Specifies the value of the Loyalty Points Provision % field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CompanyMappings)
            {
                ApplicationArea = all;
                Caption = 'Company Mappings';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = MapAccounts;
                RunObject = page "12E Company Mappings";
            }
            action(EPICGLMapping)
            {
                ApplicationArea = all;
                Caption = 'EPIC G/L Mapping';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = MapAccounts;
                RunObject = page "12E EPIC GL Mapping List";
            }
            action(EPICPaymentTypes)
            {
                ApplicationArea = all;
                Caption = 'EPIC Payment Types';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Payment;
                RunObject = page "12E EPIC Payment Types";
            }
            action(EPICBankAccounts)
            {
                ApplicationArea = all;
                Caption = 'EPIC Bank Accounts';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Payment;
                RunObject = page "12E EPIC Bank Accounts";
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
