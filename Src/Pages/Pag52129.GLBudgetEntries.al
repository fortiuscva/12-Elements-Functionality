page 52129 "12E GL Budget Entries"
{
    PageType = API;
    SourceTable = "G/L Budget Entry";
    APIPublisher = '12Elements';
    APIGroup = '12Elements';
    APIVersion = 'v2.0';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    EntityName = 'glBudgetEntry';
    EntitySetName = 'glBudgetEntries';
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // System
                field(id; Rec.SystemId) { Caption = 'Id'; }

                // Core
                field(entryNo; Rec."Entry No.") { Caption = 'Entry No.'; }
                field(budgetName; Rec."Budget Name") { Caption = 'Budget Name'; }
                field(postingDate; rec.Date) { Caption = 'Posting Date'; }

                // Account
                field(glAccountNo; Rec."G/L Account No.") { Caption = 'G/L Account No.'; }

                // Amount
                field(amount; Rec.Amount) { Caption = 'Amount'; }

                // Dimensions (same pattern as GL Entry)
                field(dimensionSetId; Rec."Dimension Set ID") { Caption = 'Dimension Set ID'; }   //mapping point

                // Optional but useful
                field(description; Rec.Description) { Caption = 'Description'; }
                field(businessUnitCode; Rec."Business Unit Code") { Caption = 'Business Unit Code'; }

                // Audit
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { Caption = 'Last Modified Date Time'; }
            }
        }
    }
}