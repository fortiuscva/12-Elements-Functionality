query 52100 "12E CCD Grouped Data"
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

            column(Portfolio; Portfolio)
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