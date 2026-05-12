query 52101 "12E CCD Location Totals"
{
    QueryType = Normal;

    elements
    {
        dataitem(CCDData; "12E CC Distribution Data")
        {
            column(CCDate; "CC Date")
            {
            }

            column(LocationCode; "Location Code")
            {
            }

            column(TotalHandleTime; "Handling Time")
            {
                Method = Sum;
            }

            dataitem(LocationMapping; "12E CC Location Mapping")
            {
                DataItemLink = "Location Code" = CCDData."Location Code";

                filter(Active; Active)
                {
                    ColumnFilter = Active = const(true);
                }
            }
        }
    }
}