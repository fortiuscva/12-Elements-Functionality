
codeunit 52120 "12E Payroll Batch Mgmt"
{
    trigger OnRun()
    begin
        CreatePayrollBatches(Today(), Today());
    end;

    procedure PreviewPayrollBatches(StartDate: Date; EndDate: Date)
    var
        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
        TempPayrollBatchHeader: Record "12E Payroll Batch Header" temporary;
        TempPayrollBatchLine: Record "12E Payroll Batch Line" temporary;
        PayrollBatchPost: Codeunit "12E Payroll Batch Post";
        ClientID: Integer;
    begin
        ClientID := GetClientID();

        QuestcoPayrollBatch.Reset();
        QuestcoPayrollBatch.SetRange("Client ID", ClientID);
        QuestcoPayrollBatch.SetRange("Payroll Doc. No.", '');
        QuestcoPayrollBatch.SetRange("Posted Payroll Doc. No.", '');

        if (StartDate <> 0D) or (EndDate <> 0D) then
            QuestcoPayrollBatch.SetRange("Pay Date", StartDate, EndDate);

        if not QuestcoPayrollBatch.FindSet() then
            Error('No eligible payroll batches were found.');

        repeat
            if not PayrollBatchExists(ClientID, QuestcoPayrollBatch."Batch ID") then begin
                Clear(TempPayrollBatchHeader);
                Clear(TempPayrollBatchLine);

                PrepareTemporaryHeader(
                    QuestcoPayrollBatch,
                    TempPayrollBatchHeader);

                PrepareTemporaryPayrollLines(
                    TempPayrollBatchHeader,
                    TempPayrollBatchLine);

                PayrollBatchPost.PreviewPayrollDocument(
                    TempPayrollBatchHeader,
                    TempPayrollBatchLine);
            end;
        until QuestcoPayrollBatch.Next() = 0;
    end;

    procedure CreatePayrollBatches(StartDate: Date; EndDate: Date)
    var
        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
        PayrollBatchHeader: Record "12E Payroll Batch Header";
        ClientID: Integer;
    begin
        ClientID := GetClientID();

        QuestcoPayrollBatch.Reset();
        QuestcoPayrollBatch.SetRange("Client ID", ClientID);
        QuestcoPayrollBatch.SetRange("Payroll Doc. No.", '');
        QuestcoPayrollBatch.SetRange("Posted Payroll Doc. No.", '');

        if (StartDate <> 0D) or (EndDate <> 0D) then
            QuestcoPayrollBatch.SetRange("Pay Date", StartDate, EndDate);

        if QuestcoPayrollBatch.FindSet() then
            repeat
                if not PayrollBatchExists(ClientID, QuestcoPayrollBatch."Batch ID") then
                    CreatePayrollBatchHeader(QuestcoPayrollBatch, PayrollBatchHeader);
            until QuestcoPayrollBatch.Next() = 0;

        if GuiAllowed() then
            Message('Payroll Documents created successfully.');
    end;

    local procedure PrepareTemporaryHeader(
        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
        var TempPayrollBatchHeader: Record "12E Payroll Batch Header" temporary)
    begin
        TempPayrollBatchHeader.Init();

        // Temporary document number used only for preview.
        TempPayrollBatchHeader."No." :=
            CopyStr(
                StrSubstNo('PREV%1', QuestcoPayrollBatch."Batch ID"),
                1,
                MaxStrLen(TempPayrollBatchHeader."No."));

        TempPayrollBatchHeader.Validate(
            "Client ID",
            QuestcoPayrollBatch."Client ID");

        TempPayrollBatchHeader.Validate(
            "Batch ID",
            QuestcoPayrollBatch."Batch ID");

        TempPayrollBatchHeader.Validate(
            "Pay Date",
            QuestcoPayrollBatch."Pay Date");

        TempPayrollBatchHeader."Batch Type" :=
            QuestcoPayrollBatch."Batch Type";

        TempPayrollBatchHeader."Pay Period Start Date" :=
            QuestcoPayrollBatch."Pay Period Start Date";

        TempPayrollBatchHeader."Pay Period End Date" :=
            QuestcoPayrollBatch."Pay Period End Date";

        TempPayrollBatchHeader.Status :=
            TempPayrollBatchHeader.Status::Open;

        TempPayrollBatchHeader.Insert(false);
    end;

    local procedure PrepareTemporaryPayrollLines(
        PayrollBatchHeader: Record "12E Payroll Batch Header";
        var TempPayrollBatchLine: Record "12E Payroll Batch Line" temporary)
    var
        PayrollBatchQuery: Query "12E Payroll Batch Data";
        CurrentLineNo: Integer;
        Amount: Decimal;
    begin
        PayrollBatchHeader.TestField("Client ID");
        PayrollBatchHeader.TestField("Batch ID");
        PayrollBatchHeader.TestField("Pay Date");
        PayrollBatchHeader.TestField("Pay Period Start Date");
        PayrollBatchHeader.TestField("Pay Period End Date");

        PayrollBatchQuery.SetRange(
            ClientID,
            PayrollBatchHeader."Client ID");

        PayrollBatchQuery.SetRange(
            BatchIDFilter,
            PayrollBatchHeader."Batch ID");

        PayrollBatchQuery.SetRange(
            PayDate,
            PayrollBatchHeader."Pay Date");

        PayrollBatchQuery.Open();

        while PayrollBatchQuery.Read() do begin
            CurrentLineNo += 10000;

            Amount :=
                PayrollBatchQuery.TotalDebit -
                PayrollBatchQuery.TotalCredit;

            TempPayrollBatchLine.Init();

            TempPayrollBatchLine."Document No." :=
                PayrollBatchHeader."No.";

            TempPayrollBatchLine."Line No." := CurrentLineNo;

            TempPayrollBatchLine."Client ID" :=
                PayrollBatchQuery.Client_ID;

            TempPayrollBatchLine."Batch ID" :=
                PayrollBatchQuery.BatchID;

            TempPayrollBatchLine."Department Code" :=
                PayrollBatchQuery.Department;

            TempPayrollBatchLine."G/L Account No." :=
                PayrollBatchQuery.GLAccountNo;

            TempPayrollBatchLine.Amount := Amount;

            Clear(TempPayrollBatchLine."Employee No.");

            TempPayrollBatchLine."Hours Worked" :=
                PayrollBatchQuery.TotalHoursWorked;

            TempPayrollBatchLine."Hours Units Paid" :=
                PayrollBatchQuery.TotalHoursPaid;

            TempPayrollBatchLine.Insert(false);
        end;

        PayrollBatchQuery.Close();

        if TempPayrollBatchLine.IsEmpty() then
            Error(
                'No payroll lines were generated for Batch ID %1.',
                PayrollBatchHeader."Batch ID");
    end;

    local procedure CreatePayrollBatchHeader(
        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
        var PayrollBatchHeader: Record "12E Payroll Batch Header")
    begin
        Clear(PayrollBatchHeader);
        PayrollBatchHeader.Init();

        PayrollBatchHeader.Insert(true);
        PayrollBatchHeader.Validate("Client ID", QuestcoPayrollBatch."Client ID");
        PayrollBatchHeader.Validate("Batch ID", QuestcoPayrollBatch."Batch ID");
        PayrollBatchHeader.Validate("Pay Date", QuestcoPayrollBatch."Pay Date");
        PayrollBatchHeader."Batch Type" := QuestcoPayrollBatch."Batch Type";
        PayrollBatchHeader."Pay Period Start Date" := QuestcoPayrollBatch."Pay Period Start Date";
        PayrollBatchHeader."Pay Period End Date" := QuestcoPayrollBatch."Pay Period End Date";
        PayrollBatchHeader.Status := PayrollBatchHeader.Status::Open;
        PayrollBatchHeader.Modify(true);

        CreatePayrollDocuments(PayrollBatchHeader);
    end;

    procedure CreatePayrollDocuments(
        var PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatchLine: Record "12E Payroll Batch Line";
        PayrollBatchQuery: Query "12E Payroll Batch Data";
        CurrentLineNo: Integer;
        Amount: Decimal;
    begin
        PayrollBatchHeader.TestField("Client ID");
        PayrollBatchHeader.TestField("Batch ID");
        PayrollBatchHeader.TestField("Pay Date");
        PayrollBatchHeader.TestField("Pay Period Start Date");
        PayrollBatchHeader.TestField("Pay Period End Date");

        DeleteExistingLines(PayrollBatchHeader);

        PayrollBatchQuery.SetRange(ClientID, PayrollBatchHeader."Client ID");
        PayrollBatchQuery.SetRange(BatchIDFilter, PayrollBatchHeader."Batch ID");
        PayrollBatchQuery.SetRange(PayDate, PayrollBatchHeader."Pay Date");

        PayrollBatchQuery.Open();

        while PayrollBatchQuery.Read() do begin
            CurrentLineNo += 10000;

            Amount := PayrollBatchQuery.TotalDebit - PayrollBatchQuery.TotalCredit;

            PayrollBatchLine.Init();
            PayrollBatchLine."Document No." := PayrollBatchHeader."No.";
            PayrollBatchLine."Line No." := CurrentLineNo;
            PayrollBatchLine."Client ID" := PayrollBatchQuery.Client_ID;
            PayrollBatchLine."Batch ID" := PayrollBatchQuery.BatchID;
            PayrollBatchLine."Department Code" := PayrollBatchQuery.Department;
            PayrollBatchLine."G/L Account No." := PayrollBatchQuery.GLAccountNo;
            PayrollBatchLine.Amount := Amount;
            Clear(PayrollBatchLine."Employee No.");

            PayrollBatchLine."Hours Worked" := PayrollBatchQuery.TotalHoursWorked;
            PayrollBatchLine."Hours Units Paid" := PayrollBatchQuery.TotalHoursPaid;
            PayrollBatchLine.Insert();
        end;

        PayrollBatchQuery.Close();
    end;

    local procedure DeleteExistingLines(
        PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatchLine: Record "12E Payroll Batch Line";
    begin
        PayrollBatchLine.Reset();
        PayrollBatchLine.SetRange("Document No.", PayrollBatchHeader."No.");
        PayrollBatchLine.DeleteAll();
    end;

    local procedure PayrollBatchExists(
        ClientID: Integer;
        BatchID: Integer): Boolean
    var
        PayrollBatchHeader: Record "12E Payroll Batch Header";
    begin
        PayrollBatchHeader.Reset();
        PayrollBatchHeader.SetRange("Client ID", ClientID);
        PayrollBatchHeader.SetRange("Batch ID", BatchID);
        exit(not PayrollBatchHeader.IsEmpty());
    end;

    local procedure GetClientID(): Integer
    var
        CompanyMapping: Record "12E Company Mapping";
        ClientID: Integer;
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetRange(Blocked, false);

        if not CompanyMapping.FindFirst() then
            Error(
                'Company Mapping does not exist for company %1.',
                CompanyName());

        CompanyMapping.TestField("Client ID");
        ClientID := CompanyMapping."Client ID";

        exit(ClientID);
    end;
}
