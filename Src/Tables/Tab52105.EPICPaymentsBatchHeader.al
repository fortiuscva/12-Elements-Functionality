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
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(10; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(15; Status; enum "12E EPIC Pay Batch Status")
        {
            Caption = 'Status';
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

    procedure PerformManualRelease()
    var
        ReleaseEPICPayBatchDoc: Codeunit "12E EPICPayBatch Release Mgmt.";
    begin
        if Rec.Status <> Rec.Status::Released then begin
            ReleaseEPICPayBatchDoc.PerformManualRelease(Rec);
            Commit();
        end;
    end;

}
