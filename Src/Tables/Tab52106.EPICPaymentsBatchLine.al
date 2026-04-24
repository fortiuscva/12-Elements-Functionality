table 52106 "12E EPIC Payments Batch Line"
{
    Caption = '12E EPIC Payments Batch Line';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Account Type"; enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(10; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(15; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Batch No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Batch No.", "Line No.")
        {

        }
    }
    trigger OnInsert()
    var
        EPICPaymentsBatchHeader: Record "12E EPIC Payments Batch Header";
    begin
        if EPICPaymentsBatchHeader.Get(Rec."Batch No.") then
            if EPICPaymentsBatchHeader."Batch Date" <> 0D then
                Rec.Validate("Posting Date", EPICPaymentsBatchHeader."Batch Date");
    end;
}
