table 52105 "12E EPIC Payments Batch Header"
{
    Caption = 'EPIC Payments Batch Header';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TwelveElementsSetup: Record "12E 12 Elements Setup";
                NoSeries: Codeunit "No. Series";
            begin
                if "Batch No." <> xRec."Batch No." then begin
                    TwelveElementsSetup.get;
                    NoSeries.TestManual(TwelveElementsSetup."EPIC Payment Batch Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(5; "Batch Date"; Date)
        {
            Caption = 'Batch Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EPICPaymentsBatchLine: Record "12E EPIC Payments Batch Line";
            begin
                if Rec."Batch Date" <> xRec."Batch Date" then begin
                    if Confirm('Lines are existed in the batch, do you want to update the posting date for all the lines?') then begin
                        EPICPaymentsBatchLine.Reset();
                        EPICPaymentsBatchLine.SetRange("Batch No.", Rec."Batch No.");
                        EPICPaymentsBatchLine.CalcFields("Posting Date");
                    end;
                end;
            end;
        }
        field(10; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(15; Status; enum "12E EPIC Pay Batch Status")
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Batch No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Batch No.")
        {

        }
    }
    trigger OnInsert()
    var
        TwelveElementsSetup: Record "12E 12 Elements Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();
        if "Batch No." = '' then begin
            TwelveElementsSetup.TestField("EPIC Payment Batch Nos.");      //To Test No. Series
            "No. Series" := TwelveElementsSetup."EPIC Payment Batch Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "Batch No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    procedure AssistEdit(OldEPICPaymentsBatchHeader: Record "12E EPIC Payments Batch Header"): Boolean
    var
        TwelveElementsSetup: Record "12E 12 Elements Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();
        if NoSeries.LookupRelatedNoSeries(TwelveElementsSetup."EPIC Payment Batch Nos.", OldEPICPaymentsBatchHeader."No. Series", "No. Series") then begin
            "Batch No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    procedure PerformManualRelease(var EPICPayBatchHeader: Record "12E EPIC Payments Batch Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
        PrevFilterGroup: Integer;
    begin
        NoOfSelected := EPICPayBatchHeader.Count;
        PrevFilterGroup := EPICPayBatchHeader.FilterGroup();
        EPICPayBatchHeader.FilterGroup(10);
        EPICPayBatchHeader.SetFilter(Status, '<>%1', EPICPayBatchHeader.Status::Released);
        NoOfSkipped := NoOfSelected - EPICPayBatchHeader.Count;
        BatchProcessingMgt.BatchProcess(EPICPayBatchHeader, Codeunit::"12E EPay Batch Manual Release", Enum::"Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
        EPICPayBatchHeader.SetRange(Status);
        EPICPayBatchHeader.FilterGroup(PrevFilterGroup);

    end;

    procedure PerformManualRelease()
    var
        ReleaseEPICPayBatchDoc: Codeunit "12E EPICPayBatch Release Mgmt.";
    begin
        if Rec.Status <> Rec.Status::Released then begin
            ReleaseEPICPayBatchDoc.PerformManualRelease(Rec);
            Commit();
        end;
    end;

    procedure PerformManualReopen(var EPICPayBatchHeader: Record "12E EPIC Payments Batch Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := EPICPayBatchHeader.Count;
        EPICPayBatchHeader.SetFilter(Status, '<>%1', EPICPayBatchHeader.Status::Open);
        NoOfSkipped := NoOfSelected - EPICPayBatchHeader.Count;
        BatchProcessingMgt.BatchProcess(EPICPayBatchHeader, Codeunit::"12E EPAY Batch Manual Reopen", Enum::"Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
    end;

}
