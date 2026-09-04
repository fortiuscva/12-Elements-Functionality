codeunit 52124 "12E Functions"
{
    procedure GetContactCenterHours(ClientIDPar: Integer; BatchIDPar: Integer; DeptCodePar: Code[20]): Decimal
    var
        PayrollTransaction: Record "12E Questco Payroll Txn";
    begin
        PayrollTransaction.Reset();
        PayrollTransaction.SetRange("Client ID", ClientIDPar);
        PayrollTransaction.SetRange("Batch ID", BatchIDPar);
        PayrollTransaction.SetRange("Department Code", DeptCodePar);
        PayrollTransaction.SetFilter("Hours Worked", '>%1', 0);
        PayrollTransaction.CalcSums("Hours Worked");

        exit(PayrollTransaction."Hours Worked");
    end;

    procedure GetPayrollCompanySpecificPostingError(ClientIdPar: Integer; BatchIdPar: Integer): Text
    var
        PayrollHeader: Record "12E Payroll Batch Header";
        CompanyName: Text[30];
    begin
        CompanyName := '';
        CompanyName := GetPayrollCompany(ClientIdPar);
        PayrollHeader.Reset();
        PayrollHeader.ChangeCompany(CompanyName);
        PayrollHeader.SetRange("Client ID", ClientIdPar);
        PayrollHeader.SetRange("Batch ID", BatchIdPar);
        if PayrollHeader.FindLast() then
            exit(PayrollHeader."Posting Error");
    end;

    local procedure GetPayrollCompany(QuestcoClientIdPar: Integer): Text[30]
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange("Client ID", QuestcoClientIdPar);
        if CompanyMapping.FindLast() then
            exit(CompanyMapping.Company);
    end;
}
