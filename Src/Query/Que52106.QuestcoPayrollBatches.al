query 52106 "12E Questco Payroll Batches"
{
    QueryType = Normal;

    elements
    {
        dataitem(PayrollTxn; "12E Questco Payroll Txn")
        {
            filter(ClientIDFilter; "Client ID")
            {
            }

            filter(BatchTypeFilter; "Batch Type")
            {
            }


            column(ClientID; "Client ID")
            {
            }

            column(BatchID; "Batch ID")
            {
            }

            column(BatchType; "Batch Type")
            {
            }

            column(PayDate; "Pay Date")
            {
            }

            column(PayPeriodStartDate; "Pay Period Start Date")
            {
            }

            column(PayPeriodEndDate; "Pay Period End Date")
            {
            }
        }
    }
}