table 52104 "12E 12 Elements Setup"
{
    Caption = '12 Elements Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(5; "EPIC Payment Batch Nos."; Code[20])
        {
            Caption = 'EPIC Payment Batch Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(10; "Balancing G/L Account"; Code[20])
        {
            Caption = 'EPIC Balancing G/L Account';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(13; "CCD Nos."; Code[20])
        {
            Caption = 'Call Center Distribution Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
