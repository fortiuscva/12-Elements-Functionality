page 52104 "12E Setup"
{
    ApplicationArea = All;
    Caption = '12 Elements Setup';
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
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Gen)
            {
                Caption = 'General';
                Image = Setup;
                action(CompanyMapping)
                {
                    ApplicationArea = all;
                    Caption = 'Company Mapping';
                    Image = MapAccounts;
                    RunObject = page "12E Company Mappings";
                }
            }
            group(CCDistribution)
            {
                Caption = 'Contact Center Distribution';
                Image = Setup;
                action(CCDLocationMapping)
                {
                    ApplicationArea = all;
                    Caption = 'CCD Location Mapping';
                    Image = MapAccounts;
                    RunObject = page "12E CCD Loc. Mapping Details";
                }
                action(CCDCustomerPortfolioMapping)
                {
                    ApplicationArea = all;
                    Caption = 'CCD Customer Portfolio Mapping';
                    Image = MapAccounts;
                    RunObject = page "12E CCDPort. Cust. Map. Detail";
                }
                action(Departments)
                {
                    ApplicationArea = all;
                    Caption = 'Departments';
                    Image = Departments;
                    RunObject = page "12E Department Codes";
                }
                action(PayTypes)
                {
                    ApplicationArea = all;
                    Caption = 'Pay Types';
                    Image = SetupPayment;
                    RunObject = page "12E Pay Types";
                }
            }
        }
        area(Promoted)
        {
            group(Category_Category4)
            {
                Caption = 'General', Comment = 'Generated from the PromotedActionCategories property index 3.';
                actionref(CompanyMapping_Promoted; CompanyMapping)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Contact Center Distribution', Comment = 'Generated from the PromotedActionCategories property index 4.';
                actionref(CCDLocationMapping_Promoted; CCDLocationMapping)
                {
                }
                actionref(CCDCustomerPortfolioMapping_Promoted; CCDCustomerPortfolioMapping)
                {
                }
                actionref(Departments_Promoted; Departments)
                {
                }
                actionref(PayTypes_Promoted; PayTypes)
                {
                }
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
