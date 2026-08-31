table 52120 "12E Lead Accrual"
{
    Caption = 'Lead Accrual';
    LookupPageId = "12E Lead Accruals";
    DrillDownPageId = "12E Lead Accruals";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                TwelveElementsSetup: Record "12E Setup";
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    TwelveElementsSetup.Get();
                    NoSeries.TestManual(TwelveElementsSetup."Lead Accrual Nos.");
                    "No. Series" := '';
                end;
            end;
        }

        field(2; Year; Integer)
        {
            Caption = 'Year';

            trigger OnValidate()
            begin
                if Year <> xRec.Year then
                    CheckLinesBeforePeriodChange();

                UpdatePeriodDates();
            end;
        }

        field(3; Month; Enum "12E Accrual Month")
        {
            Caption = 'Month';

            trigger OnValidate()
            begin
                if Year <> xRec.Year then
                    CheckLinesBeforePeriodChange();

                UpdatePeriodDates();
            end;
        }

        field(4; "From Date"; Date)
        {
            Caption = 'From Date';
            Editable = false;
        }

        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
            Editable = false;
        }

        field(6; Status; Enum "12E EPIC Pay Batch Status")
        {
            Caption = 'Status';
            Editable = false;
        }

        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(8; "G/L Register No."; Integer)
        {
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
        }
        field(10; "Posting Error"; Text[2048])
        {
            Caption = 'Posting Error';
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
        fieldgroup(DropDown; "No.", Year, Month, "From Date", "To Date")
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
            TwelveElementsSetup.TestField("Lead Accrual Nos.");

            "No. Series" := TwelveElementsSetup."Lead Accrual Nos.";

            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";

            "No." := NoSeries.GetNextNo("No. Series");
        end;

        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        AccrualLine: Record "12E Lead Accrual Line";
    begin
        AccrualLine.Reset();
        AccrualLine.SetRange("Lead Accrual No.", Rec."No.");
        if AccrualLine.FindSet() then
            AccrualLine.DeleteAll(true);
    end;

    procedure AssistEdit(OldLeadAccrual: Record "12E Lead Accrual"): Boolean
    var
        TwelveElementsSetup: Record "12E Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();

        if NoSeries.LookupRelatedNoSeries(
            TwelveElementsSetup."Lead Accrual Nos.",
            OldLeadAccrual."No. Series",
            "No. Series")
        then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    local procedure UpdatePeriodDates()
    var
        MonthNo: Integer;
    begin
        if (Year = 0) or (Format(Month) = '') then begin
            Clear("From Date");
            Clear("To Date");
            exit;
        end;

        case Month of
            Month::Jan:
                MonthNo := 1;
            Month::Feb:
                MonthNo := 2;
            Month::Mar:
                MonthNo := 3;
            Month::Apr:
                MonthNo := 4;
            Month::May:
                MonthNo := 5;
            Month::Jun:
                MonthNo := 6;
            Month::Jul:
                MonthNo := 7;
            Month::Aug:
                MonthNo := 8;
            Month::Sep:
                MonthNo := 9;
            Month::Oct:
                MonthNo := 10;
            Month::Nov:
                MonthNo := 11;
            Month::Dec:
                MonthNo := 12;
        end;

        "From Date" := DMY2Date(1, MonthNo, Year);
        "To Date" := CalcDate('<CM>', "From Date");
    end;

    procedure PerformManualRelease(var LeadAccrual: Record "12E Lead Accrual")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
        PrevFilterGroup: Integer;
    begin
        NoOfSelected := LeadAccrual.Count;
        PrevFilterGroup := LeadAccrual.FilterGroup();

        LeadAccrual.FilterGroup(10);
        LeadAccrual.SetFilter(Status, '<>%1', LeadAccrual.Status::Released);

        NoOfSkipped := NoOfSelected - LeadAccrual.Count;

        BatchProcessingMgt.BatchProcess(
            LeadAccrual,
            Codeunit::"12E LeadAccrual Manual Release",
            Enum::"Error Handling Options"::"Show Error",
            NoOfSelected,
            NoOfSkipped);

        LeadAccrual.SetRange(Status);
        LeadAccrual.FilterGroup(PrevFilterGroup);
    end;

    procedure PerformManualRelease()
    var
        ReleaseLeadAccrualDoc: Codeunit "12E Lead Accrual Release Mgmt";
    begin
        if Status <> Status::Released then begin
            ReleaseLeadAccrualDoc.PerformManualRelease(Rec);
            Commit();
        end;
    end;

    procedure PerformManualReopen(var LeadAccrual: Record "12E Lead Accrual")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := LeadAccrual.Count;

        LeadAccrual.SetFilter(Status, '<>%1', LeadAccrual.Status::Open);

        NoOfSkipped := NoOfSelected - LeadAccrual.Count;

        BatchProcessingMgt.BatchProcess(
            LeadAccrual,
            Codeunit::"12E LeadAccrual Manual Reopen",
            Enum::"Error Handling Options"::"Show Error",
            NoOfSelected,
            NoOfSkipped);
    end;

    procedure ValidateAccrualPeriod()
    begin
        TestField(Year);
        TestField(Month);
    end;

    local procedure CheckLinesBeforePeriodChange()
    var
        LeadAccrualLine: Record "12E Lead Accrual Line";
    begin
        LeadAccrualLine.SetRange("Lead Accrual No.", "No.");
        if not LeadAccrualLine.IsEmpty() then
            Error('You cannot change the Year or Month when Lead Accrual lines exist. Delete the lines first.');
    end;
}
