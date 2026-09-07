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
            group(Leads)
            {
                Caption = 'Leads';

                group(Reconciliation)
                {
                    Caption = 'Leads Reconciliation';

                }

                group(Accruals)
                {
                    Caption = 'Accruals';

                    field("Lead Accrual Jnl. Template"; Rec."Lead Accrual Jnl. Template")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Lead Accrual Journal Template field.', Comment = '%';
                    }

                    field("Lead Accrual Jnl. Batch"; Rec."Lead Accrual Jnl. Batch")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Lead Accrual Journal Batch field.', Comment = '%';
                    }
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("EPIC Payment Batch Nos."; Rec."EPIC Payment Batch Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EPIC Payment Batch Nos. field.', Comment = '%';
                }
                field("CCD Nos."; Rec."CCD Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Call Center Distribution Nos. field.', Comment = '%';
                }
                field("Lead Accrual Nos."; Rec."Lead Accrual Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Accrual Nos. field.', Comment = '%';
                }
                field("Payroll Doc. No's."; Rec."Payroll Doc. No's.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Batch Nos. field.', Comment = '%';
                }
                field("Loyalty Document Nos."; Rec."Loyalty Document Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loyalty Document Nos. field.', Comment = '%';
                }
                field("LMS Batch Document Nos."; Rec."LMS Batch Document Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to generate LMS Batch document numbers.';
                }
                field("LMS Transaction Document Nos."; Rec."LMS Transaction Document Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to generate LMS Transaction document numbers.';
                }
            }
            group(CCD)
            {
                Caption = 'Contact Center Distribution';
                field("CCD G/L Account No."; Rec."CCD G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CCD G/L Account No. field.', Comment = '%';
                }
                field("Enable CCD Process"; Rec."Enable CCD Process")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Process Enabled field.', Comment = '%';
                }
                field("Process Dialer Tone Invoices"; Rec."Process Dialer Tone Invoices")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether Posted Purchase Invoices for RDTJ should be processed for Contact Center Distribution.';
                }
            }
            group(PayrollProcessing)
            {
                Caption = 'Payroll Processing';

                field("Payroll Jnl. Template"; Rec."Payroll Jnl. Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Journal Template field.', Comment = '%';
                }

                field("Payroll Jnl. Batch"; Rec."Payroll Jnl. Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Journal Batch field.', Comment = '%';
                }

                field("Payroll Offset Account No."; Rec."Payroll Offset Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Offset Account No. field.', Comment = '%';
                }
            }
            group(LoyaltyPoints)
            {
                Caption = 'Loyalty Points';
                group("Earned/Expired")
                {
                    Caption = 'Earned/Expired';
                    field("Loyalty Points Earned"; Rec."Loyalty Points Earned")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EPIC Payment Batch Nos. field.', Comment = '%';
                    }
                    field("Deferred Rev Loyalty Pts"; Rec."Deferred Rev Loyalty Pts")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EPIC Payment Batch Nos. field.', Comment = '%';
                    }
                }
                group(Provision)
                {
                    Caption = 'Provision';
                    field("Loyalty Pts. Provision %"; Rec."Loyalty Pts. Provision %")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Loyalty Points Provision % field.', Comment = '%';
                    }
                    field("Loyalty Points Provision"; Rec."Loyalty Points Provision")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Provision for Loyalty Points field.', Comment = '%';
                    }
                    field("Loyalty Points Reserve"; Rec."Loyalty Points Reserve")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Loyalty Points Reserve field.', Comment = '%';
                    }
                }
                field("Loyalty Source Code"; Rec."Loyalty Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loyalty Source Code field.', Comment = '%';
                }
                field("Loyalty Reason Code"; Rec."Loyalty Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loyalty Reason Code field.', Comment = '%';
                }

                field("Loyalty Jnl. Template"; Rec."Loyalty Jnl. Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loyalty Journal Template field.', Comment = '%';
                }
                field("Loyalty Jnl. Batch"; Rec."Loyalty Jnl. Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loyalty Journal Batch field.', Comment = '%';
                }
                field("Enable Loyalty Process"; Rec."Enable Loyalty Process")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enable Loyalty Process field.', Comment = '%';
                }
            }
            group(LMS)
            {
                Caption = 'LMS';

                group(LMSBatch)
                {
                    Caption = 'LMS Batch';

                    field("LMS Batch Jnl. Template Name"; Rec."LMS Batch Jnl. Template Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the General Journal Template used for LMS Batch posting.';
                    }

                    field("LMS Batch Jnl. Batch Name"; Rec."LMS Batch Jnl. Batch Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the General Journal Batch used for LMS Batch posting.';
                    }

                }

                group(LMSTransactions)
                {
                    Caption = 'LMS Transactions';

                    field("LMS Transaction Jnl. Template"; Rec."LMS Transaction Jnl. Template")
                    {
                        ApplicationArea = All;
                    }

                    field("LMS Transaction Jnl. Batch"; Rec."LMS Transaction Jnl. Batch")
                    {
                        ApplicationArea = All;
                    }

                    field("LMS Source Code"; Rec."LMS Source Code")
                    {
                        ApplicationArea = All;
                    }

                    field("LMS Reason Code"; Rec."LMS Reason Code")
                    {
                        ApplicationArea = All;
                    }
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
                    ApplicationArea = All;
                    Caption = 'Company Mappings';
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
