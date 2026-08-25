pageextension 52109 "12E Vendor List" extends "Vendor List"
{
    actions
    {
        addlast(Navigation)
        {
            group("12E Leads")
            {
                Caption = 'Leads';
                Image = Navigate;

                action("12E OpenLeadReconciliationSource")
                {
                    ApplicationArea = All;
                    Caption = 'Open Lead Reconciliation Source';
                    Image = Navigate;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        LeadSource: Record "12E Lead Source Reconciliation";
                        CompanyMapping: Record "12E Company Mapping";
                    begin
                        if Rec."12E Lead Acq. Vendor No." = '' then
                            Error('Lead Provider must be specified for vendor %1.', Rec."No.");

                        CompanyMapping.Reset();
                        CompanyMapping.SetRange(Company, CompanyName());

                        if not CompanyMapping.FindFirst() then
                            Error('Data Source ID is not configured for company %1.', CompanyName());

                        LeadSource.Reset();
                        LeadSource.SetRange("Datasource ID", CompanyMapping."DataSource ID");
                        LeadSource.SetRange("Lead Provider", Rec."12E Lead Acq. Vendor No.");

                        Page.Run(Page::"12E Leads Data by Portfolio", LeadSource);
                    end;
                }
            }
        }
    }
}
