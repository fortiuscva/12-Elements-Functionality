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

    procedure HandleFailedJob(var JobQueue: Record "Job Queue Entry")
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        BodyText: Text;
        EnvironmentInformation: Codeunit "Environment Information";
        EmailSubject: Text;
    begin
        if JobQueue."12E Set Ready When Failed" then begin
            JobQueue.Status := JobQueue.Status::Ready;
            JobQueue.Modify();
        end;

        if JobQueue."12E Send Failure Notification" then begin
            EmailSubject := StrSubstNo('[%1] Job Queue Failure Alert', EnvironmentInformation.GetEnvironmentName());
            BodyText :=
                'Job Queue has failed with the following error message<br><br>' +
                'Description: ' + JobQueue.Description + '<br>' +
                'Object Type: ' + Format(JobQueue."Object Type to Run") + '<br>' +
                'Object ID: ' + Format(JobQueue."Object ID to Run") + '<br>' +
                'Error Message:<br>' + JobQueue."Error Message";

            EmailMessage.Create(JobQueue."12E Notify All EmailRecipients", EmailSubject, BodyText, true);

            if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then;
        end;
    end;
}
