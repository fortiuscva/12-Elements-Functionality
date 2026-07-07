page 52131 "12E Accounting Periods"
{
    PageType = API;
    SourceTable = "Accounting Period";
    APIPublisher = '12Elements';
    APIGroup = '12Elements';
    APIVersion = 'v2.0';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    EntityName = 'accountingPeriod';
    EntitySetName = 'accountingPeriods';
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // System
                field(id; Rec.SystemId) { Caption = 'Id'; }

                // Core fields
                field(startingDate; Rec."Starting Date") { Caption = 'Starting Date'; }
                field(name; Rec.Name) { Caption = 'Name'; }

                // Period flags
                field(newFiscalYear; Rec."New Fiscal Year") { Caption = 'New Fiscal Year'; }
                field(closed; Rec.Closed) { Caption = 'Closed'; }
                field(dateLocked; Rec."Date Locked") { Caption = 'Date Locked'; }
            }
        }
    }
}