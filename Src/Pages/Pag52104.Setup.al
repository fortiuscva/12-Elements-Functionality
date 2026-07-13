page 52104 "12E Setup"
{
    ApplicationArea = All;
    Caption = 'Setup';
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
}
