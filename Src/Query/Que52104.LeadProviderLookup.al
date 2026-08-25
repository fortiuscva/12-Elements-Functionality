query 52104 "12E Lead Provider Lookup"
{
    Caption = 'Lead Provider Lookup';

    QueryType = Normal;

    elements
    {
        dataitem(LeadSource; "12E Lead Source Reconciliation")
        {
            column(DatasourceID; "Datasource ID")
            {
            }

            column(LeadProvider; "Lead Provider")
            {
            }

            filter(DatasourceFilter; "Datasource ID")
            {
            }
        }
    }
}
