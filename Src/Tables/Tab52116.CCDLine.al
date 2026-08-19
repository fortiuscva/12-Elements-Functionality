table 52116 "12E CCD Line"
{
    Caption = 'CCD Line';
    DataClassification = CustomerContent;
    DataPerCompany = True;
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "12E CCD Header";
            DataClassification = CustomerContent;

        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        // field(5; "Call Date"; Date)
        // {
        //     Caption = 'Call Date';
        //     DataClassification = CustomerContent;
        // }
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
        field(11; "Handling Time"; Integer)
        {
            Caption = 'Handling Time';
            DataClassification = CustomerContent;
        }
        field(13; Percentage; Decimal)
        {
            Caption = 'Percentage';
            DecimalPlaces = 0 : 2;
            MaxValue = 100;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(17; "No. of Hours"; Decimal)
        {
            Caption = 'No. of Hours';
            DataClassification = CustomerContent;
        }
        field(19; "Distributed Quantity"; Decimal)
        {
            Caption = 'Distributed Quantity';
            DataClassification = CustomerContent;
        }
        field(21; "Payroll Batch ID"; Integer)
        {
            Caption = 'Batch ID';
            DataClassification = CustomerContent;
        }
        field(22; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            DataClassification = CustomerContent;
        }
        field(23; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = CustomerContent;
        }
        field(25; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = CustomerContent;
        }
        // field(27; "Invoice Date"; Date)
        // {
        //     Caption = 'Posted Purchase Invoice Date';
        //     DataClassification = CustomerContent;
        // }
        field(29; "Batch or Inv. Hours"; Decimal)
        {
            Caption = 'Batch/Invoice Hours';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(31; "Batch or Inv. Percentage"; Decimal)
        {
            Caption = 'Batch/Invoice Hours Distribution Percentage';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
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
