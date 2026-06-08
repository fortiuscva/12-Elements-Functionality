table 52121 "12E Lead Accrual Line"
{
    Caption = 'Lead Accrual Line';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Lead Accrual No."; Code[20])
        {
            Caption = 'Lead Accrual No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            trigger OnValidate()
            var
                VendorRec: Record Vendor;
            begin
                if ((Rec."Vendor No." <> xRec."Vendor No.") and (Rec."Vendor No." <> '')) then begin
                    VendorRec.Reset();
                    VendorRec.Get("Vendor No.");
                    "Vendor Name" := VendorRec.Name;
                end else begin
                    "Vendor Name" := '';
                end;
            end;
        }
        field(5; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(7; "Last PPI Posting Date"; Date)
        {
            Caption = 'Last Posted Purchase Invoice Posting Date';
        }
        field(8; "Lead Acq. Cost Vendor"; Decimal)
        {
            Caption = 'Lead Acquisition Costs for this Vendor';
        }
        field(10; "Accrual Amount"; Decimal)
        {
            Caption = 'Accrual Amount';
        }
        field(11; "Adjust Accrual Amount"; Decimal)
        {
            Caption = 'Adjust Accrual Amount';
        }
    }
    keys
    {
        key(PK; "Lead Accrual No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
