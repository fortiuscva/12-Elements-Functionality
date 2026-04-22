table 52107 "Posted EPIC Pay Batch Header"
{
    Caption = 'Posted EPIC Payments Batch Header';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(15; Status; Enum "12E EPIC Pay Batch Status")
        {
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "Batch No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Batch No.")
        {

        }
    }
}
