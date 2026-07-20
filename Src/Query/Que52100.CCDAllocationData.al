query 52100 "12E CCD Allocation Data"
{
    QueryType = Normal;

    elements
    {
        dataitem(CCDData; "12E CCD Detailed Data")
        {
            filter(CallDate; "Call Date")
            {
            }

            column(LocationCode; "Location Code")
            {
            }

            column(Portfolio; Portfolio)
            {
            }

            column(TotalHandleTime; "Handling Time")
            {
                Method = Sum;
            }

            dataitem(LocationMapping; "12E CCD Location Mapping")
            {
                DataItemLink = "Location Code" = CCDData."Location Code";

                filter(Blocked; Blocked)
                {
                    ColumnFilter = Blocked = const(false);
                }
            }
        }
    }
}