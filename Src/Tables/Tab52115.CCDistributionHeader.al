table 52115 "12E CC Distribution Header"
{
    Caption = '12E CC Distribution Header';
    LookupPageId = "12E CCD Interface List";
    DrillDownPageId = "12E CCD Interface List";
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
                    NoSeries.TestManual(TwelveElementsSetup."CCD Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(7; Status; Enum "12E EPIC Pay Batch Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(10; "No. Series"; Code[20])
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
    trigger OnInsert()
    var
        TwelveElementsSetup: Record "12E 12 Elements Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();
        if "No." = '' then begin
            TwelveElementsSetup.TestField("CCD Nos.");      //To Test No. Series
            "No. Series" := TwelveElementsSetup."CCD Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    procedure AssistEdit(OldCCDHeader: Record "12E CC Distribution Header"): Boolean
    var
        TwelveElementsSetup: Record "12E 12 Elements Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();
        if NoSeries.LookupRelatedNoSeries(TwelveElementsSetup."CCD Nos.", OldCCDHeader."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    procedure PerformManualRelease(var CCDHeader: Record "12E CC Distribution Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
        PrevFilterGroup: Integer;
    begin
        NoOfSelected := CCDHeader.Count;
        PrevFilterGroup := CCDHeader.FilterGroup();
        CCDHeader.FilterGroup(10);
        CCDHeader.SetFilter(Status, '<>%1', CCDHeader.Status::Released);
        NoOfSkipped := NoOfSelected - CCDHeader.Count;
        BatchProcessingMgt.BatchProcess(CCDHeader, Codeunit::"12E CCD Manual Release", Enum::"Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
        CCDHeader.SetRange(Status);
        CCDHeader.FilterGroup(PrevFilterGroup);
    end;

    procedure PerformManualRelease()
    var
        ReleaseCCDDoc: Codeunit "12E CCD Release Mgmt";
    begin
        if Rec.Status <> Rec.Status::Released then begin
            ReleaseCCDDoc.PerformManualRelease(Rec);
            Commit();
        end;
    end;

    procedure PerformManualReopen(var CCDHeader: Record "12E CC Distribution Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := CCDHeader.Count;
        CCDHeader.SetFilter(Status, '<>%1', CCDHeader.Status::Open);
        NoOfSkipped := NoOfSelected - CCDHeader.Count;
        BatchProcessingMgt.BatchProcess(CCDHeader, Codeunit::"12E CCD Manual Reopen", Enum::"Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
    end;
}
