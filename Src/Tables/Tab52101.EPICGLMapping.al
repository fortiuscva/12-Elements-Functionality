table 52101 "12E EPIC GL Mapping"
{
    Caption = '12E EPIC GL Mapping';
    LookupPageId = "12E EPIC GL Mapping List";
    DrillDownPageId = "12E EPIC GL Mapping List";
    DataCaptionFields = "Loan Status", "Data Source ID";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Loan Status"; Enum "12E EPIC Loan Status")
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(5; "Data Source ID"; Integer)
        {
            Caption = 'Data Source ID';
            TableRelation = "12E EPIC DataSourceID Map";
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(15; "Principal G/L Account No."; Code[20])
        {
            Caption = 'Principal G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(20; "Finance Fee G/L Account No."; Code[20])
        {
            Caption = 'Finance Fee G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(25; "NSF Fee G/L Account No."; Code[20])
        {
            Caption = 'NSF Fee G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(30; "Late Fee G/L Account No."; Code[20])
        {
            Caption = 'Late Fee G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Loan Status", "Data Source ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(EPICGLMapping; "Loan Status", "Data Source ID")
        {

        }
    }
}
