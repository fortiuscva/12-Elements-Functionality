codeunit 52124 "12E Functions"
{
    procedure GetContactCenterHours(ClientIDPar: Integer; BatchIDPar: Integer; DeptCodePar: Code[20]): Decimal
    var
        PayrollTxn: Record "12E Questco Payroll Txn";
    begin
        PayrollTxn.Reset();
        PayrollTxn.SetRange("Client ID", ClientIDPar);
        PayrollTxn.SetRange("Batch ID", BatchIDPar);
        PayrollTxn.SetRange("Department Code", DeptCodePar);
        PayrollTxn.SetFilter("Hours Worked", '>%1', 0);
        PayrollTxn.CalcSums("Hours Worked");

        exit(PayrollTxn."Hours Worked");
    end;
}
