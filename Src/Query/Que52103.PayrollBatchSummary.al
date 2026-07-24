query 52103 "12E Payroll Batch Summary"
{
    QueryType = Normal;

    elements
    {
        dataitem(Payroll; "12E Questco Payroll Txn")
        {
            filter(PayDate; "Pay Date")
            {
            }

            column(BatchID; "Batch ID")
            {
            }

            column(TotalHours; "Hours Worked")
            {
                Method = Sum;
            }
        }
    }
}