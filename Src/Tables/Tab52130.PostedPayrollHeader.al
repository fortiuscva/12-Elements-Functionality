table 52130 "12E Posted Payroll Header"
{
    Caption = 'Posted Payroll Header';
    DataPerCompany = true;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Status; enum "12E Payroll Batch Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(3; "Client ID"; Integer)
        {
            Caption = 'Client ID';
            DataClassification = CustomerContent;
        }
        field(4; "Batch ID"; Integer)
        {
            Caption = 'Batch ID';
            DataClassification = CustomerContent;
        }
        field(5; "Pay Date"; Date)
        {
            Caption = 'Pay Date';
            DataClassification = CustomerContent;
        }
        field(6; "Batch Type"; Code[10])
        {
            Caption = 'Batch Type';
            DataClassification = CustomerContent;
        }
        field(7; "Pay Period Start Date"; Date)
        {
            Caption = 'Pay Period Start Date';
            DataClassification = CustomerContent;
        }
        field(8; "Pay Period End Date"; Date)
        {
            Caption = 'Pay Period End Date';
            DataClassification = CustomerContent;
        }
        field(11; "Posting Error"; Text[250])
        {
            Caption = 'Posting Error';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "G/L Register No."; Integer)
        {
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Client ID", "Batch ID")
        {

        }
    }
    trigger OnDelete()
    begin
        DeleteAllPostedPayrollLines();
    end;

    procedure DeleteAllPostedPayrollLines()
    var
        PostedPayrollLine: Record "12E Posted Payroll Line";
    begin
        PostedPayrollLine.SetRange("Document No.", Rec."No.");
        PostedPayrollLine.DeleteAll(true);
    end;

}
