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
        field(6; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = "12E CCD Location Mapping";
            DataClassification = CustomerContent;
        }
        field(10; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Document No." where("Document Type" = const(Invoice), "12E CCD No." = field("No.")));
        }

        field(11; "Posted Sales Invoice No."; Code[20])
        {
            Caption = 'Posted Sales Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Line"."Document No." where("12E CCD No." = field("No.")));
        }
        field(17; "No. of Hours"; Decimal)
        {
            Caption = 'Batch/Invoice Hours';
            DataClassification = CustomerContent;
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
        fieldgroup(DropDown; "No.", "Location Code", "Period Start Date", "Period End Date", "Payroll Batch ID")
        {
        }
        fieldgroup(Brick; "No.", "Location Code", "Period Start Date", "Period End Date", "Payroll Batch ID")
        {
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