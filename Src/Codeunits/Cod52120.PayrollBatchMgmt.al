codeunit 52120 "12E Payroll Batch Mgmt"
{
    procedure CreatePayrollDocuments(var PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatchLine: Record "12E Payroll Batch Line";
        PayrollBatchQuery: Query "12E Payroll Batch Data";
        CurrentLineNo: Integer;
        Amount: Decimal;
    begin
        if PayrollBatchHeader."Batch Status" = PayrollBatchHeader."Batch Status"::Processed then
            Error(
                'Lines cannot be created because Payroll batch %1 has already been processed.',
                PayrollBatchHeader."No.");

        PayrollBatchHeader.TestField("Client ID");
        PayrollBatchHeader.TestField("Pay Date");

        DeleteExistingLines(PayrollBatchHeader);

        PayrollBatchQuery.SetRange(ClientID, PayrollBatchHeader."Client ID");
        PayrollBatchQuery.SetRange(PayDate, PayrollBatchHeader."Pay Date");

        PayrollBatchQuery.Open();

        while PayrollBatchQuery.Read() do begin
            CurrentLineNo += 10000;

            Amount := PayrollBatchQuery.TotalDebit - PayrollBatchQuery.TotalCredit;

            PayrollBatchLine.Init();
            PayrollBatchLine."Document No." := PayrollBatchHeader."No.";
            PayrollBatchLine."Line No." := CurrentLineNo;

            PayrollBatchLine."Department Code" := PayrollBatchQuery.Department;
            PayrollBatchLine."G/L Account No." := PayrollBatchQuery.GLAccountNo;
            PayrollBatchLine.Amount := Amount;

            Clear(PayrollBatchLine."Employee No.");
            Clear(PayrollBatchLine."Pay Type Code");

            PayrollBatchLine."Hours Worked" := PayrollBatchQuery.TotalHoursWorked;
            PayrollBatchLine."Hours Units Paid" := PayrollBatchQuery.TotalHoursPaid;
            PayrollBatchLine.Insert();
        end;

        PayrollBatchQuery.Close();

        Message('Payroll Documents created successfully.');
    end;

    local procedure DeleteExistingLines(PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatchLine: Record "12E Payroll Batch Line";
    begin
        PayrollBatchLine.SetRange("Document No.", PayrollBatchHeader."No.");
        PayrollBatchLine.DeleteAll();
    end;
}