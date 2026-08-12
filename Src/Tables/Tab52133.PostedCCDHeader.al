table 52133 "12E Posted CCD Header"
{
    Caption = 'Posted CCD Header';
    LookupPageId = "12E Posted CCD Details";
    DrillDownPageId = "12E Posted CCD Details";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Payroll Batch ID"; Integer)
        {
            Caption = 'Batch ID';
            DataClassification = CustomerContent;
        }
        field(3; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = CustomerContent;
        }
        field(4; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            DataClassification = CustomerContent;
        }
        field(5; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = CustomerContent;
        }
        field(6; "Sales Invoices Exist"; Boolean)
        {
            Caption = 'Sales Invoices Exist';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Line" where("12E CCD No." = field("No."), "Document Type" = const(Invoice)));
            Editable = false;
        }
        field(7; "Posted Sales Invoices Exist"; Boolean)
        {
            Caption = 'Posted Sales Invoices Exist';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Invoice Line" where("12E CCD No." = field("No.")));
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
    trigger OnDelete()
    var
        PostedCCDLine: Record "12E Posted CCD Line";
    begin
        PostedCCDLine.Reset();
        PostedCCDLine.SetRange("Document No.", "No.");
        PostedCCDLine.DeleteAll(true);
    end;
}