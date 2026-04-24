query 52150 "12E EPIC Payment Summary"
{
    elements
    {
        dataitem(Payment; "12E EPIC Payment")
        {
            filter(SuccessDateFilter; "Success Date") { }
            filter(StatusFilter; "Payment Status") { }
            column(DataSourceID; "Data Source ID") { }
            column(LoanStatus; "Loan Status") { }
            column(County; County) { }
            column(StoreCode; "Store Code") { }

            column(Principal; Principal) { Method = Sum; }
            column(LateFee; "Late Fee") { Method = Sum; }
            column(NSFFee; "NSF Fee") { Method = Sum; }
            column(FinanceFee; "Finance Fee") { Method = Sum; }
        }
    }
}