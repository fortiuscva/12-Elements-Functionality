page 52143 "12E Payroll Transactions"
{
    APIGroup = '12Elements';
    APIPublisher = '12Elements';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Payroll Transactions';
    DelayedInsert = true;
    EntityName = 'payrollTransaction';
    EntitySetName = 'payrollTransactions';
    PageType = API;
    SourceTable = "12E Questco Payroll Txn";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(pkID; Rec."PK ID")
                {
                    Caption = 'PK ID';
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
                field(payPeriodStartDate; Rec."Pay Period Start Date")
                {
                    Caption = 'Pay Period Start Date';
                }
                field(payPeriodEndDate; Rec."Pay Period End Date")
                {
                    Caption = 'Pay Period End Date';
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(departmentCode; Rec."Department Code")
                {
                    Caption = 'Department Code';
                }
                field(gLAccountNo; Rec."G/L Account No.")
                {
                    Caption = 'G/L Account No.';
                }
                field(payTypeCode; Rec."Pay Type Code")
                {
                    Caption = 'Pay Type Code';
                }
                field(debitAmount; Rec."Debit Amount")
                {
                    Caption = 'Debit Amount';
                }
                field(creditAmount; Rec."Credit Amount")
                {
                    Caption = 'Credit Amount';
                }
                field(hoursWorked; Rec."Hours Worked")
                {
                    Caption = 'Hours Worked';
                }
                field(hoursUnitsPaid; Rec."Hours Units Paid")
                {
                    Caption = 'Hours Units Paid';
                }
                field(dwExportTimestamp; Rec."DW Export Timestamp")
                {
                    Caption = 'DWExportTimestamp';
                }
                field(erpImportTimestamp; Rec."ERP Import Timestamp")
                {
                    Caption = 'ERPImportTimestamp';
                }
                field(erpStatus; Rec."ERP Status")
                {
                    Caption = 'ERPStatus';
                }
                field(erpErrorMsg; Rec."ERP Error Msg")
                {
                    Caption = 'ERPErrorMsg';
                }
                field(postingError; Rec."Posting Error")
                {
                    Caption = 'Posting Error Message';
                }
                field(exportBatchID; Rec."Export Batch ID")
                {
                    Caption = 'Export Batch ID';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Validations.CheckQuestcoClientIDMapping(Rec."Client ID");
        Validations.CheckWhetherPayrollBatchExists(Rec."Client ID", Rec."Batch ID");
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
