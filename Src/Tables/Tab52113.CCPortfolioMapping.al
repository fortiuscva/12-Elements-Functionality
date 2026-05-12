table 52113 "12E CC Portfolio Mapping"
{
    Caption = 'Call Center Portfolio Mapping';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; Portfolio; Text[30])
        {
            Caption = 'Portfolio';
            DataClassification = CustomerContent;
        }
        field(3; "DataSource ID"; Integer)
        {
            Caption = 'DataSource ID';
            DataClassification = CustomerContent;
        }
        field(5; Company; Text[30])
        {
            Caption = 'Company';
            DataClassification = CustomerContent;
            TableRelation = Company;
        }
        field(7; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(9; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
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
        fieldgroup(DropDown; Portfolio, "DataSource ID")
        {

        }
    }
}
