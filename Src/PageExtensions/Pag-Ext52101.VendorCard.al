pageextension 52101 "12E Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter(Receiving)
        {
            group("12E Leads")
            {
                Caption = 'Leads';

                group("12E LeadReconciliation")
                {
                    Caption = 'Lead Reconciliation';

                    field("12E Lead Reconciliation"; Rec."12E Lead Reconciliation")
                    {
                        ApplicationArea = All;
                    }

                    field("12E Lead Acquisition Vendor No."; Rec."12E Lead Vendor")
                    {
                        ApplicationArea = All;
                        Caption = 'Lead Vendor';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            CompanyMapping: Record "12E Company Mapping";
                            LeadProviderLookup: Page "12E Lead Vendor Lookup";
                        begin
                            CompanyMapping.SetRange(Company, CompanyName());

                            if not CompanyMapping.FindFirst() then
                                exit(false);

                            LeadProviderLookup.LoadProviders(
                                CompanyMapping."DataSource ID");

                            if LeadProviderLookup.RunModal() = Action::LookupOK then begin
                                Rec."12E Lead Vendor" :=
                                    LeadProviderLookup.GetSelectedProvider();

                                Text := Rec."12E Lead Vendor";
                                exit(true);
                            end;

                            exit(false);
                        end;
                    }

                    field("12E Lead Billing Terms"; Rec."12E Lead Billing Terms")
                    {
                        ApplicationArea = All;
                    }
                }

                group("12E LeadAccrual")
                {
                    Caption = 'Lead Accrual';

                    field("12E Lead Accrual"; Rec."12E Lead Accrual")
                    {
                        ApplicationArea = All;
                    }

                    field("12E Lead Credit Account No."; Rec."12E Lead Credit Account No.")
                    {
                        ApplicationArea = All;
                    }

                    field("12E Lead Debit Account No."; Rec."12E Lead Debit Account No.")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            group("12E  Leads")
            {
                Caption = 'Leads';
                Image = Navigate;

                action("12E OpenLeadReconciliationSource")
                {
                    ApplicationArea = All;
                    Caption = 'Open Lead Reconciliation Source';
                    Image = Navigate;

                    trigger OnAction()
                    var
                        LeadSource: Record "12E Lead Source Reconciliation";
                        CompanyMapping: Record "12E Company Mapping";
                    begin
                        if Rec."12E Lead Vendor" = '' then Error('Lead Vendor must be specified for vendor %1.', Rec."No.");
                        CompanyMapping.SetRange(Company, CompanyName());
                        if not CompanyMapping.FindFirst() then Error('Data Source ID is not configured for company %1.', CompanyName());
                        LeadSource.SetRange("Datasource ID", CompanyMapping."DataSource ID");
                        LeadSource.SetRange("Lead Vendor", Rec."12E Lead Vendor");
                        Page.Run(Page::"12E Leads Data by Portfolio", LeadSource);
                    end;
                }
            }
        }

        addbefore(Category_Category5)
        {
            group("12E Category_Leads")
            {
                Caption = 'Leads';
                Image = Navigate;

                actionref(OpenLeadReconciliationSource_Promoted; "12E OpenLeadReconciliationSource")
                {
                }
            }
        }
    }
}