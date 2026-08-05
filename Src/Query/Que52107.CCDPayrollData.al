query 52107 "12E CCD Payroll Data"
{
    QueryType = Normal;

    elements
    {
        dataitem(PayrollTxn; "12E Questco Payroll Txn")
        {
            filter(ClientID; "Client ID")
            {
            }
            filter(BatchIDFilter; "Batch ID")
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

            column(TotalHoursPaid; "Hours Units Paid")
            {
                Method = Sum;
            }
            dataitem(PayType; "12E Pay Type")
            {
                DataItemLink = "Pay Type Code" = PayrollTxn."Pay Type Code";
                filter(ContactCenter; "Contact Center")
                {
                    ColumnFilter = ContactCenter = Const(true);
                }
            }
        }
    }
}
