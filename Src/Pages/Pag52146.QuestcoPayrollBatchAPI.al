page 52146 "12E Questco Payroll Batch API"
{
    APIGroup = '12Elements';
    APIPublisher = '12Elements';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Questco Payroll Batch API';
    DelayedInsert = true;
    EntityName = 'questcoPayrollBatch';
    EntitySetName = 'questcoPayrollBatches';
    PageType = API;
    SourceTable = "12E Questco Payroll Batch";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(pkid; Rec.PKID)
                {
                    Caption = 'PKID';
                }
                field(dwLoadDate; Rec.DWLoadDate)
                {
                    Caption = 'DWLoadDate';
                }
                field(clientID; Rec."Client ID")
                {
                    Caption = 'Client ID';
                }
                field(batchID; Rec."Batch ID")
                {
                    Caption = 'Batch ID';
                }
                field(payDate; Rec."Pay Date")
                {
                    Caption = 'Pay Date';
                }
                field(batchType; Rec."Batch Type")
                {
                    Caption = 'Batch Type';
                }
                field(batchStatus; Rec."Batch Status")
                {
                    Caption = 'Batch Status';
                }
                field(payGroupID; Rec."Pay Group ID")
                {
                    Caption = 'Pay Group ID';
                }
                field(payPeriodStartDate; Rec."Pay Period Start Date")
                {
                    Caption = 'Pay Period Start Date';
                }
                field(payPeriodEndDate; Rec."Pay Period End Date")
                {
                    Caption = 'Pay Period End Date';
                }
                field(weeksWorked; Rec."Weeks Worked")
                {
                    Caption = 'Weeks Worked';
                }
                field(deductPeriod; Rec."Deduct Period")
                {
                    Caption = 'Deduct Period';
                }
                field(dwExportTimestamp; Rec."DW Export Timestamp")
                {
                    Caption = 'DW Export Timestamp';
                }
                field(erpImportTimestamp; Rec."ERP Import Timestamp")
                {
                    Caption = 'ERP Import Timestamp';
                }
                field(erpStatus; Rec."ERP Status")
                {
                    Caption = 'ERP Status';
                }
                field(erpErrorMessage; Rec."ERP Error Message")
                {
                    Caption = 'ERP Error Message';
                }
                field(postingErrorMessage; PostingErrorMessage)
                {
                    Caption = 'Posting Error Message';
                }
                field(etlBatchID; Rec."ETL Batch ID")
                {
                    Caption = 'ETL Batch ID';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Validations.CheckQuestcoClientIDMapping(Rec."Client ID");
        exit(true);
    end;

    trigger OnAfterGetRecord()
    begin
        PostingErrorMessage := Functions.GetPayrollCompanySpecificPostingError(Rec."Client ID", Rec."Batch ID");
    end;

    var
        Validations: Codeunit "12E Validations";
        Functions: Codeunit "12E Functions";
        PostingErrorMessage: Text;
}
