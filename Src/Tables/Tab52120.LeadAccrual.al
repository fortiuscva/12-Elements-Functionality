table 52120 "12E Lead Accrual"
{
    Caption = 'Lead Accrual';
    LookupPageId = "12E Lead Accruals";
    DrillDownPageId = "12E Lead Accruals";
    DataClassification = CustomerContent;
    DataPerCompany = false;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TwelveElementsSetup: Record "12E 12 Elements Setup";
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    TwelveElementsSetup.get;
                    NoSeries.TestManual(TwelveElementsSetup."Lead Accrual Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = CustomerContent;
        }
        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = CustomerContent;
        }
        field(7; Status; Enum "12E EPIC Pay Batch Status")
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(9; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
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
        fieldgroup(DropDown; "No.", "From Date", "To Date")
        {

        }
    }
    trigger OnInsert()
    var
        TwelveElementsSetup: Record "12E 12 Elements Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();
        if "No." = '' then begin
            TwelveElementsSetup.TestField("Lead Accrual Nos.");      //To Test No. Series
            "No. Series" := TwelveElementsSetup."Lead Accrual Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    procedure AssistEdit(OldLeadAccrual: Record "12E Lead Accrual"): Boolean
    var
        TwelveElementsSetup: Record "12E 12 Elements Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();
        if NoSeries.LookupRelatedNoSeries(TwelveElementsSetup."Lead Accrual Nos.", OldLeadAccrual."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
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
        BatchProcessingMgt.BatchProcess(LeadAccrual, Codeunit::"12E LeadAccrual Manual Release", Enum::"Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
        LeadAccrual.SetRange(Status);
        LeadAccrual.FilterGroup(PrevFilterGroup);

    end;

    procedure PerformManualRelease()
    var
        ReleaseLeadAccrualDoc: Codeunit "12E Lead Accrual Release Mgmt";
    begin
        if Rec.Status <> Rec.Status::Released then begin
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
        BatchProcessingMgt.BatchProcess(LeadAccrual, Codeunit::"12E LeadAccrual Manual Reopen", Enum::"Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
    end;
}
