page 52144 "12E CCD Detailed Data Entries"
{
    APIGroup = '12Elements';
    APIPublisher = '12Elements';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'eCCDDetailedDataEntries';
    DelayedInsert = true;
    EntityName = 'ccdDetailedDataEntry';
    EntitySetName = 'ccdDetailedDataEntries';
    PageType = API;
    SourceTable = "12E CCD Detailed Data";

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
                field(callDate; Rec."Call Date")
                {
                    Caption = 'Call Date';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(portfolio; Rec.Portfolio)
                {
                    Caption = 'Portfolio';
                }
                field(handlingTime; Rec."Handling Time")
                {
                    Caption = 'Handling Time';
                }
                field(allocatedCost; Rec."Allocated Cost")
                {
                    Caption = 'Allocated Cost';
                }
                field(dwExportTimestamp; Rec."DW Export Timestamp")
                {
                    Caption = 'DW Export Timestamp';
                }
                field(erpImportTimestamp; Rec."ERP Import Timestamp")
                {
                    Caption = 'ERP Import Timestamp';
                }
                field(erpStatus; Rec.ERPStatus)
                {
                    Caption = 'ERPStatus';
                }
                field(erpErrorMsg; Rec.ERPErrorMsg)
                {
                    Caption = 'ERPErrorMsg';
                }
                field(batchID; Rec."Batch ID")
                {
                    Caption = 'Batch ID';
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
        Validations.CheckPortfolioMapping(Rec.Portfolio);
        exit(true);
    end;

    var
        Validations: Codeunit "12E Validations";
}
