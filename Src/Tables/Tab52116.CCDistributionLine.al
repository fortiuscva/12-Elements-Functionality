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
        }
        field(9; Portfolio; Text[30])
        {
            Caption = 'Portfolio';
        }
        field(11; "Handling Time"; Integer)
        {
            Caption = 'Handling Time';
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
