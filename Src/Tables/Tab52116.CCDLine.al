table 52116 "12E CCD Line"
{
    Caption = 'Contact Center Time Distribution Line';
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
        field(5; "Call Date"; Date)
        {
            Caption = 'Call Date';
            DataClassification = CustomerContent;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = "12E CCD Location Mapping";
            // ValidateTableRelation = false;
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
        field(15; "Distribution Total"; Decimal)
        {
            Caption = 'Distribution Total';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("12E CCD Allocation Details"."CCD Location Hours" where("CCD Location" = field("Location Code")));
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
        // field(15; "Sales Invoice No."; Code[20])
        // {
        //     Caption = 'Sales Invoice No.';
        //     Editable = false;
        // }

        // field(17; "Sales Invoice Line No."; Integer)
        // {
        //     Caption = 'Sales Invoice Line No.';
        //     Editable = false;
        // }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
