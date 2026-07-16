table 52124 "12E Pay Type"
{
    Caption = '12E Pay Type';
    LookupPageId = "12E Pay Types";
    DrillDownPageId = "12E Pay Types";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Pay Type Code"; Code[20])
        {
            Caption = 'Pay Type Code';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Contact Center"; Boolean)
        {
            Caption = 'Contact Center';
            DataClassification = CustomerContent;
        }
        field(6; "Do not process for payroll"; Boolean)
        {
            Caption = 'Do not process for payroll';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Pay Type Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Pay Type Code", Description, "Contact Center", "Do not process for payroll")
        {

        }
    }
}
