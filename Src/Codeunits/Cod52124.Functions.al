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

    procedure HandleFailedJob(var JobQueue: Record "Job Queue Entry")
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        BodyText: Text;
    begin
        if JobQueue."12E Set Ready When Failed" then begin
            JobQueue.Status := JobQueue.Status::Ready;
            JobQueue.Modify();
        end;

        if JobQueue."12E Send Failure Notification" then begin
            BodyText :=
                'Job Queue has failed with the following error message<br><br>' +
                'Description: ' + JobQueue.Description + '<br>' +
                'Object Type: ' + Format(JobQueue."Object Type to Run") + '<br>' +
                'Object ID: ' + Format(JobQueue."Object ID to Run") + '<br>' +
                'Error Message:<br>' + JobQueue."Error Message";

            EmailMessage.Create(JobQueue."12E Notify All EmailRecipients", 'Job Queue Failure Alert', BodyText, true);

            if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then;
        end;
    end;
}