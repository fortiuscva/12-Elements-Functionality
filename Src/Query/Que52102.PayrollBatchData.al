query 52102 "12E Payroll Batch Data"
{
    QueryType = Normal;

    elements
    {
        dataitem(PayrollTxn; "12E Questco Payroll Txn")
        {
            filter(ClientID; "Client ID")
            {
            }

            filter(PayDate; "Pay Date")
            {
            }

            column(BatchID; "Batch ID")
            {
            }

            column(Department; "Department Code")
            {
            }

            column(GLAccountNo; "G/L Account No.")
            {
            }

            column(TotalDebit; "Debit Amount")
            {
                Method = Sum;
            }

            column(TotalCredit; "Credit Amount")
            {
                Method = Sum;
            }
            column(TotalHoursWorked; "Hours Worked")
            {
                Method = Sum;
            }

            column(TotalHoursPaid; "Hours Paid")
            {
                Method = Sum;
            }
        }
    }
}
