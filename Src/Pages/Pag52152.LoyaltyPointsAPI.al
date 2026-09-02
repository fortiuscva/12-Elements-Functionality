page 52152 "12E Loyalty Points API"
{
    APIGroup = '12Elements';
    APIPublisher = '12Elements';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'loyaltyPointsAPI';
    DelayedInsert = true;
    EntityName = 'loyaltyPoint';
    EntitySetName = 'loyaltyPoints';
    PageType = API;
    SourceTable = "12E Loyalty Points";

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
                field(portfolio; Rec.Portfolio)
                {
                    Caption = 'Portfolio';
                }
                field(state; Rec.State)
                {
                    Caption = 'State';
                }
                field(store; Rec."Store Name")
                {
                    Caption = 'Store';
                }
                field(monthEndDate; Rec."Month End Date")
                {
                    Caption = 'Month End Date';
                }
                field(pointsEarned; Rec."Points Earned")
                {
                    Caption = 'Points Earned';
                }
                field(pointsExpired; Rec."Points Expired")
                {
                    Caption = 'Points Expired';
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
                field(exportBatchID; Rec."Export Batch ID")
                {
                    Caption = 'Export Batch ID';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ValidationsCUGbl.CheckPortfolioMapping(Rec.Portfolio);
        exit(true);
    end;

    var
        ValidationsCUGbl: Codeunit "12E Validations";
}
