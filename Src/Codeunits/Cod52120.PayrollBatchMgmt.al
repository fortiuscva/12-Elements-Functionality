codeunit 52120 "12E Payroll Batch Mgmt"
{
    trigger OnRun()
    begin
        CreatePayrollBatches();
    end;

    procedure CreatePayrollBatches()
    var
        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
        PayrollBatchHeader: Record "12E Payroll Batch Header";
        ClientID: Integer;
        WorkDate: Date;
    begin
        ClientID := GetClientID();
        WorkDate := Today();

        QuestcoPayrollBatch.Reset();
        // QuestcoPayrollBatch.SetRange("Payroll Processed", false);
        QuestcoPayrollBatch.SetRange("Client ID", ClientID);
        QuestcoPayrollBatch.SetRange("Payroll Doc. No.", '');
        QuestcoPayrollBatch.SetRange("Posted Payroll Doc. No.", '');
        if QuestcoPayrollBatch.FindSet() then
            repeat
                if not PayrollBatchExists(ClientID, QuestcoPayrollBatch."Batch ID")
                then
                    CreatePayrollBatchHeader(QuestcoPayrollBatch, PayrollBatchHeader);

            until QuestcoPayrollBatch.Next() = 0;
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
        if GuiAllowed() then
            Message('Payroll Documents created successfully.');
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
        CompanyMapping.SetRange(Company, CompanyName);
        CompanyMapping.SetRange(Blocked, false);
        if not CompanyMapping.FindFirst() then
            Error(
                'Company Mapping does not exist for company %1.',
                CompanyName);

        CompanyMapping.TestField("Client ID");
        ClientID := CompanyMapping."Client ID";
        // if CompanyMapping.Next() <> 0 then
        //     Error(
        //         'Multiple active Company Mappings exist for company %1.',
        //         CompanyName);

        exit(ClientID);
    end;
}