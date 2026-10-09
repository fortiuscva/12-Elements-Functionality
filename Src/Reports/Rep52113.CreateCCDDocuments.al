report 52113 "12E Create CCD Documents"
{
    Caption = 'Create CCD Documents';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }

                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = Action::OK then begin
                if (StartDate <> 0D) and
                   (EndDate <> 0D) and
                   (EndDate < StartDate)
                then
                    Error('End Date cannot be earlier than Start Date.');
            end;

            exit(true);
        end;
    }

    trigger OnPreReport()
    var
        CCDMgt: Codeunit "12E CCD Mgmt";
    begin
        if (StartDate <> 0D) or (EndDate <> 0D) then
            if (StartDate = 0D) or (EndDate = 0D) then
                Error('Start Date and End Date cannot be blank.');

        CCDMgt.CreateCCDDocuments(StartDate, EndDate);
    end;

    var
        StartDate: Date;
        EndDate: Date;
}