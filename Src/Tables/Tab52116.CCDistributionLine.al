table 52116 "12E CC Distribution Line"
{
    Caption = '12E CC Distribution Line';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "CCD Date"; Date)
        {
            Caption = 'Date';
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            ValidateTableRelation = false;
        }
        field(9; Portfolio; Text[30])
        {
            Caption = 'Portfolio';
        }
        field(11; "Handle Time"; Duration)
        {
            Caption = 'Handle Time';
        }
        field(13; Percentage; Decimal)
        {
            Caption = 'Percentage';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(15; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            Editable = false;
        }

        field(17; "Sales Invoice Line No."; Integer)
        {
            Caption = 'Sales Invoice Line No.';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
