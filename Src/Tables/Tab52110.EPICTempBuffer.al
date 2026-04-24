table 52110 "12E EPIC Temp Buffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Data Source ID"; Integer) { }
        field(2; "GL Account"; Code[20]) { }
        field(3; Amount; Decimal) { }
        field(4; County; Text[30]) { }
        field(5; "Store Code"; Code[20]) { }
    }

    keys
    {
        key(PK; "Data Source ID", "GL Account", County, "Store Code") { }
    }
}