table 52138 "12E LMS Transaction Header"
{
    Caption = 'LMS Transaction Header';
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
                    NoSeries.TestManual(TwelveElementsSetup."LMS Transaction Document Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(3; "Datasource ID"; Integer)
        {
            Caption = 'Datasource ID';
            TableRelation = "12E EPIC DataSource";
            DataClassification = CustomerContent;
        }
        field(4; "Error Exists"; Boolean)
        {
            Caption = 'Error Exists';
            DataClassification = CustomerContent;
        }
        field(5; Status; Enum "12E LMS Document Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }

        field(36; "Posting Error"; Text[2048])
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
        fieldgroup(DropDown; "No.", "Datasource ID", "Transaction Date", "Error Exists")
        {
        }
        fieldgroup(Brick; "No.", "Datasource ID", "Transaction Date", "Error Exists")
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
            TwelveElementsSetup.TestField("LMS Transaction Document Nos.");

            "No. Series" := TwelveElementsSetup."LMS Transaction Document Nos.";

            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";

            "No." := NoSeries.GetNextNo("No. Series");

            Status := Status::Open;
        end;
    end;

    trigger OnDelete()
    begin
        DeleteAllLMSTransactionLines();
    end;

    trigger OnRename()
    var
        RestrictRenameErrorLbl: Label 'LMS Transaction Document No. %1 cannot be changed.';
    begin
        if "No." <> xRec."No." then
            Error(StrSubstNo(RestrictRenameErrorLbl, xRec."No."));
    end;

    procedure AssistEdit(OldLMSTransactionHeader: Record "12E LMS Transaction Header"): Boolean
    var
        TwelveElementsSetup: Record "12E Setup";
        NoSeries: Codeunit "No. Series";
    begin
        TwelveElementsSetup.Get();

        if NoSeries.LookupRelatedNoSeries(
            TwelveElementsSetup."LMS Transaction Document Nos.",
            OldLMSTransactionHeader."No. Series",
            "No. Series")
        then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    procedure PerformManualRelease(var LMSTransactionHeader: Record "12E LMS Transaction Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
        PrevFilterGroup: Integer;
    begin
        NoOfSelected := LMSTransactionHeader.Count;
        PrevFilterGroup := LMSTransactionHeader.FilterGroup();

        LMSTransactionHeader.FilterGroup(10);
        LMSTransactionHeader.SetFilter(Status, '<>%1', LMSTransactionHeader.Status::Released);

        NoOfSkipped := NoOfSelected - LMSTransactionHeader.Count;

        BatchProcessingMgt.BatchProcess(
            LMSTransactionHeader,
            Codeunit::"12E LMS Manual Release",
            Enum::"Error Handling Options"::"Show Error",
            NoOfSelected,
            NoOfSkipped);

        LMSTransactionHeader.SetRange(Status);
        LMSTransactionHeader.FilterGroup(PrevFilterGroup);
    end;

    procedure PerformManualRelease()
    var
        ReleaseLMSDoc: Codeunit "12E LMS Release Mgt.";
    begin
        if Status <> Status::Released then begin
            ReleaseLMSDoc.PerformManualRelease(Rec);
            Commit();
        end;
    end;

    procedure PerformManualReopen(var LMSTransactionHeader: Record "12E LMS Transaction Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := LMSTransactionHeader.Count;

        LMSTransactionHeader.SetFilter(Status, '<>%1', LMSTransactionHeader.Status::Open);

        NoOfSkipped := NoOfSelected - LMSTransactionHeader.Count;

        BatchProcessingMgt.BatchProcess(
            LMSTransactionHeader,
            Codeunit::"12E LMS Manual Reopen",
            Enum::"Error Handling Options"::"Show Error",
            NoOfSelected,
            NoOfSkipped);
    end;

    local procedure DeleteAllLMSTransactionLines()
    var
        LMSTransactionLine: Record "12E LMS Transaction Line";
    begin
        LMSTransactionLine.Reset();
        LMSTransactionLine.SetRange("Document No.", "No.");
        LMSTransactionLine.DeleteAll(true);
    end;
}
