table 52132 "12E Loyalty Points"
{
    Caption = 'Loyalty Points';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "PK ID"; Integer)
        {
            Caption = 'PK ID';
            DataClassification = CustomerContent;
        }
        field(2; DWLoadDate; DateTime)
        {
            Caption = 'DWLoadDate';
            DataClassification = CustomerContent;
        }
        field(3; Portfolio; Text[30])
        {
            Caption = 'Portfolio';
            TableRelation = "12E CCD Port. Cust. Mapping";
            DataClassification = CustomerContent;
        }
        field(4; State; Code[20])
        {
            Caption = 'State';
            DataClassification = CustomerContent;
        }
        field(5; Store; Code[20])
        {
            Caption = 'Store';
            DataClassification = CustomerContent;
        }
        field(6; "Month End Date"; Date)
        {
            Caption = 'Month End Date';
            DataClassification = CustomerContent;
        }
        field(7; "Points Earned"; Decimal)
        {
            Caption = 'Points Earned';
            DataClassification = CustomerContent;
        }
        field(8; "Points Expired"; Decimal)
        {
            Caption = 'Points Expired';
            DataClassification = CustomerContent;
        }
        field(9; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(10; "G/L Register No."; Code[10])
        {
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
        }
        field(11; "DW Export Timestamp"; DateTime)
        {
            Caption = 'DW Export Timestamp';
            DataClassification = CustomerContent;
        }
        field(12; "ERP Import Timestamp"; DateTime)
        {
            Caption = 'ERP Import Timestamp';
            DataClassification = CustomerContent;
        }
        field(13; ERPStatus; Text[50])
        {
            Caption = 'ERPStatus';
            DataClassification = CustomerContent;
        }
        field(14; ERPErrorMsg; Text[250])
        {
            Caption = 'ERPErrorMsg';
            DataClassification = CustomerContent;
        }
        field(15; "Export Batch ID"; Guid)
        {
            Caption = 'Export Batch ID';
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
}
