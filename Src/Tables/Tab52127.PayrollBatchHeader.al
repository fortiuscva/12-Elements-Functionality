table 52127 "12E Payroll Batch Header"
{
    Caption = '12E Payroll Batch Header';
    DataPerCompany = true;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TwelveElementsSetup: Record "12E Setup";
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    TwelveElementsSetup.Get();
                    NoSeries.TestManual(TwelveElementsSetup."Payroll Doc. No's.");
                    "No. Series" := '';
                end;
            end;
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
        field(9; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(11; "Posting Error"; Text[2048])
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
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("12E Payroll Batch Line".Amount where("Document No." = field("No.")));
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
    trigger OnInsert()
    var
        TwelveElementsSetup: Record "12E Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            TwelveElementsSetup.Get();
            TwelveElementsSetup.TestField("Payroll Doc. No's.");

            "No. Series" := TwelveElementsSetup."Payroll Doc. No's.";

            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";

            "No." := NoSeries.GetNextNo("No. Series");

            Status := Status::Open;
        end;
    end;

    trigger OnRename()
    begin
        if "No." <> xRec."No." then
            Error('Payroll Document No. cannot be changed.');
    end;

    procedure AssistEdit(OldPayrollBatchHeader: Record "12E Payroll Batch Header"): Boolean
    var
        TwelveElementsSetup: Record "12E Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();

        if NoSeries.LookupRelatedNoSeries(
            TwelveElementsSetup."Payroll Doc. No's.",
            OldPayrollBatchHeader."No. Series",
            "No. Series")
        then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    procedure PerformManualRelease(var PayrollHeader: Record "12E Payroll Batch Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
        PrevFilterGroup: Integer;
    begin
        NoOfSelected := PayrollHeader.Count;
        PrevFilterGroup := PayrollHeader.FilterGroup();

        PayrollHeader.FilterGroup(10);
        PayrollHeader.SetFilter(Status, '<>%1', PayrollHeader.Status::Released);

        NoOfSkipped := NoOfSelected - PayrollHeader.Count;

        BatchProcessingMgt.BatchProcess(
            PayrollHeader,
            Codeunit::"12E Payroll Manual Release",
            Enum::"Error Handling Options"::"Show Error",
            NoOfSelected,
            NoOfSkipped);

        PayrollHeader.SetRange(Status);
        PayrollHeader.FilterGroup(PrevFilterGroup);
    end;


    procedure PerformManualRelease()
    var
        ReleasePayrollDoc: Codeunit "12E Payroll Release Mgmt";
    begin
        if Status <> Status::Released then begin
            ReleasePayrollDoc.PerformManualRelease(Rec);
            Commit();
        end;
    end;

    procedure PerformManualReopen(var PayrollHeader: Record "12E Payroll Batch Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := PayrollHeader.Count;

        PayrollHeader.SetFilter(Status, '<>%1', PayrollHeader.Status::Open);

        NoOfSkipped := NoOfSelected - PayrollHeader.Count;

        BatchProcessingMgt.BatchProcess(
            PayrollHeader,
            Codeunit::"12E Payroll Manual Reopen",
            Enum::"Error Handling Options"::"Show Error",
            NoOfSelected,
            NoOfSkipped);
    end;

    trigger OnDelete()
    begin
        DeleteAllPayrollBatchLines();
    end;

    procedure DeleteAllPayrollBatchLines()
    var
        PayrollLine: Record "12E Payroll Batch Line";
    begin
        PayrollLine.SetRange("Document No.", Rec."No.");
        PayrollLine.DeleteAll(true);
    end;

}
