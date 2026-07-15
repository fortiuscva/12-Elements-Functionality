table 52112 "12E CCD Detailed Data"
{
    Caption = 'CCD Detailed Data';
    LookupPageId = "12E CCD Data";
    DrillDownPageId = "12E CCD Data";
    DataClassification = CustomerContent;
    DataPerCompany = false;
    fields
    {
        field(1; "PK ID"; BigInteger)
        {
            Caption = 'PK ID';
            DataClassification = CustomerContent;
        }
        field(3; DWLoadDate; DateTime)
        {
            Caption = 'DWLoadDate';
            DataClassification = CustomerContent;
        }
        field(5; "Call Date"; Date)
        {
            Caption = 'Call Date';
            DataClassification = CustomerContent;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = "12E CCD Location Mapping";
            DataClassification = CustomerContent;
        }
        field(9; Portfolio; Text[30])
        {
            Caption = 'Portfolio';
            TableRelation = "12E CCD Port. Cust. Mapping";
            DataClassification = CustomerContent;
        }
        field(10; "Handling Time"; BigInteger)
        {
            Caption = 'Handling Time';
            DataClassification = CustomerContent;
        }
        field(11; "Allocated Cost"; Decimal)
        {
            Caption = 'Allocated Cost';
            DataClassification = CustomerContent;
        }
        field(13; "DW Export Timestamp"; DateTime)
        {
            Caption = 'DW Export Timestamp';
            DataClassification = CustomerContent;
        }
        field(15; "ERP Import Timestamp"; DateTime)
        {
            Caption = 'ERP Import Timestamp';
            DataClassification = CustomerContent;
        }
        field(17; ERPStatus; Text[50])
        {
            Caption = 'ERPStatus';
            DataClassification = CustomerContent;
        }
        field(16; ERPErrorMsg; Text[200])
        {
            Caption = 'ERPErrorMsg';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "PK ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Call Date", DWLoadDate, "Location Code")
        {

        }
    }
}
