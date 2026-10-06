query 52110 "12E LMS Payment Batch Group"
{
    QueryType = Normal;

    elements
    {
        dataitem(LMSTransaction; "12E LMS Transaction")
        {
            column(DatasourceID; "Datasource ID")
            {
            }

            column(PaymentID; "Payment ID")
            {
            }

            column(BatchID; "Batch ID")
            {
            }
        }
    }
}