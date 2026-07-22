page 52128 "12E Lead Providers Data"
{
    APIGroup = '12Elements';
    APIPublisher = '12Elements';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Lead Providers Data';
    DelayedInsert = true;
    EntityName = 'leadProvider';
    EntitySetName = 'leadProviders';
    PageType = API;
    SourceTable = "12E Lead Source Reconciliation";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(pkID; Rec."PK ID")
                {
                    Caption = 'PK ID';
                }
                field(dwLoadDate; Rec."DW Load Date")
                {
                    Caption = 'DW Load Date';
                }
                field(datasourceID; Rec."Datasource ID")
                {
                    Caption = 'Datasource ID';
                }
                field(portfolioName; Rec."Portfolio Name")
                {
                    Caption = 'Portfolio Name';
                }
                field(leadOriginalDate; Rec."Lead Original Date")
                {
                    Caption = 'Lead Original Date';
                }
                field(leadProvider; Rec."Lead Provider")
                {
                    Caption = 'Lead Provider';
                }
                field(purchasedLeads; Rec."Purchased Leads")
                {
                    Caption = 'Purchased Leads';
                }
                field(leadSoldCost; Rec."Lead Sold Cost")
                {
                    Caption = 'Lead Sold Cost';
                }
                field(dwExportDateTime; Rec."DW Export DateTime")
                {
                    Caption = 'DW Export DateTime';
                }
                field(erpImportDateTime; Rec."ERP Import DateTime")
                {
                    Caption = 'ERP Import DateTime';
                }
                field(erpStatus; Rec."ERP Status")
                {
                    Caption = 'ERP Status';
                }
                field(erpErrorMsg; Rec."ERP Error Msg")
                {
                    Caption = 'ERP Error Msg';
                }
                field(batchID; Rec."Batch ID")
                {
                    Caption = 'Batch ID';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
            }
        }
    }
}
