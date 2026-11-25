
report 52129 "12E Job Queue Scheduler"
{
    Caption = 'Enable 12E Job Queue Scheduler';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Administration;

    dataset
    {
        dataitem(Company; Company)
        {
            DataItemTableView = sorting(Name);

            trigger OnAfterGetRecord()
            begin
                ScheduleCompanyJobs(Company.Name);
            end;
        }
    }

    trigger OnPreReport()
    begin
        Message('Job Queue scheduling completed.');
    end;

    local procedure ScheduleCompanyJobs(TargetCompany: Text[30])
    var
        Setup: Record "12E Setup";
    begin
        Setup.ChangeCompany(TargetCompany);
        if not Setup.Get() then
            exit;


        // Loyalty - Monthly
        if Setup."Enable Loyalty Process" then
            EnsureMonthlyJob(TargetCompany, Report::"12E Loyalty Posting", 'Loyalty - Posting');

        // CCI - Every 14 Days
        if Setup."Enable CCD Process" then
            EnsureRecurringJob(TargetCompany, Report::"12E Create CCD Documents", 'CCI - Create Documents', 20160);

        // Payroll - Every 14 Days
        if Setup."Enable Payroll Process" then
            EnsureRecurringJob(TargetCompany, Report::"12E Create Payroll Documents", 'Payroll - Create Documents', 20160);

        // LMS excluded until schedule is finalized.

        // Banking Reconciliation
        if Setup."Enable Payment Reconciliation" then
            EnsureRecurringJob(TargetCompany, Report::"12E Create Bank Reconciliation", 'Payment Reconciliation', 20160);
    end;

    local procedure EnsureMonthlyJob(TargetCompany: Text[30]; ObjectID: Integer; JobDescription: Text[250])
    var
        JobQueueEntry: Record "Job Queue Entry";
        MinutesBetweenRuns: Integer;
    begin
        JobQueueEntry.ChangeCompany(TargetCompany);
        JobQueueEntry.Reset();
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Report);
        JobQueueEntry.SetRange("Object ID to Run", ObjectID);
        JobQueueEntry.SetRange("Recurring Job", true);

        if JobQueueEntry.FindFirst() then
            exit;

        MinutesBetweenRuns := GetMinutesUntilMonthEnd();
        InsertJobQueueEntry(TargetCompany, ObjectID, JobDescription, true, MinutesBetweenRuns);
    end;

    local procedure GetMinutesUntilMonthEnd(): Integer
    var
        MonthEndDate: Date;
        MonthEndDateTime: DateTime;
        Minutes: BigInteger;
    begin
        MonthEndDate := CalcDate('<CM>', WorkDate());
        if MonthEndDate <= WorkDate() then
            MonthEndDate := CalcDate('<CM>', CalcDate('<1M>', WorkDate()));

        MonthEndDateTime := CreateDateTime(MonthEndDate, 000000T);
        Minutes := (MonthEndDateTime - CurrentDateTime) div 60000;

        if Minutes <= 0 then
            exit(1);

        exit(Minutes);
    end;

    local procedure EnsureRecurringJob(TargetCompany: Text[30]; ObjectID: Integer; JobDescription: Text[250]; MinutesBetweenRuns: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.ChangeCompany(TargetCompany);
        JobQueueEntry.Reset();
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Report);
        JobQueueEntry.SetRange("Object ID to Run", ObjectID);
        JobQueueEntry.SetRange("Recurring Job", true);

        if JobQueueEntry.FindFirst() then
            exit;

        InsertJobQueueEntry(TargetCompany, ObjectID, JobDescription, true, MinutesBetweenRuns);
    end;

    local procedure InsertJobQueueEntry(TargetCompany: Text[30]; ObjectID: Integer; JobDescription: Text[250]; IsRecurring: Boolean; MinutesBetweenRuns: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.ChangeCompany(TargetCompany);
        JobQueueEntry.Init();
        JobQueueEntry.ID := CreateGuid();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Report;
        JobQueueEntry."Object ID to Run" := ObjectID;
        JobQueueEntry.Description := JobDescription;
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime;
        JobQueueEntry."Recurring Job" := IsRecurring;
        JobQueueEntry."No. of Minutes between Runs" := MinutesBetweenRuns;
        JobQueueEntry."Maximum No. of Attempts to Run" := 3;
        JobQueueEntry."User ID" := UserId;
        JobQueueEntry.Status := JobQueueEntry.Status::Ready;
        JobQueueEntry.Insert(true);
    end;
}
