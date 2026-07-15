table 52113 "12E CCD Port. Cust. Mapping"
{
    Caption = 'CCD Portfolio Customer Mapping';
    LookupPageId = "12E CCDPort. Cust. Map. Detail";
    DrillDownPageId = "12E CCDPort. Cust. Map. Detail";
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; Portfolio; Text[30])
        {
            Caption = 'Portfolio';
            DataClassification = CustomerContent;
        }
        field(7; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Portfolio)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Portfolio, "Customer No.")
        {

        }
    }
}
