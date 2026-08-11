table 52133 "12E Posted CCD Header"
{
    Caption = 'Posted CCD Header';
    LookupPageId = "12E Posted CCD Details";
    DrillDownPageId = "12E Posted CCD Details";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}