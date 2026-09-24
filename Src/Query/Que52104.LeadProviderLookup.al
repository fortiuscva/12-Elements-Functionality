query 52104 "12E Lead Vendor Lookup"
{
    Caption = 'Lead Vendor Lookup';

    QueryType = Normal;

    elements
    {
        dataitem(LeadSource; "12E Lead Source Reconciliation")
        {
            column(DatasourceID; "Datasource ID")
            {
            }

            column(LeadProvider; "Lead Vendor")
            {
            }

            filter(DatasourceFilter; "Datasource ID")
            {
            }
        }
    }
}
