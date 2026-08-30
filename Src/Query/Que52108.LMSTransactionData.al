query 52108 "12E LMS Transaction Data"
{
    QueryType = Normal;

    elements
    {
        dataitem(LMSTransaction; "12E LMS Transaction")
        {
            filter(ERPStatus; "ERP Status")
            {
                ColumnFilter = ERPStatus = const('');
            }

            filter(LMS_Transaction_Details_No_; "LMS Transaction Details No.")
            {
                ColumnFilter = LMS_Transaction_Details_No_ = const('');
            }

            column(DatasourceID; "Datasource ID")
            {
            }

            column(TransactionPostingDate; "Transaction Posting Date")
            {
            }

            column(State; State)
            {
            }

            column(Store; Store)
            {
            }

            column(DebitAccountNo; "Debit Account No.")
            {
            }

            column(CreditAccountNo; "Credit Account No.")
            {
            }

            column(Amount; Amount)
            {
                Method = Sum;
            }

            dataitem(CompanyMapping; "12E Company Mapping")
            {
                DataItemLink = "DataSource ID" = LMSTransaction."Datasource ID";

                filter(Company; Company)
                {
                }

                filter(Blocked; Blocked)
                {
                    ColumnFilter = Blocked = const(false);
                }
            }
        }
    }
}