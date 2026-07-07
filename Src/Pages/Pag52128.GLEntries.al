page 52128 "12E GL Entries"
{
    PageType = API;
    SourceTable = "G/L Entry";
    APIPublisher = '12Elements';
    APIGroup = '12Elements';
    APIVersion = 'v2.0';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    EntityName = 'glEntry';
    EntitySetName = 'glEntries';
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
                field(entryNo; Rec."Entry No.") { Caption = 'Entry No.'; }
                field(postingDate; Rec."Posting Date") { Caption = 'Posting Date'; }
                field(documentNo; Rec."Document No.") { Caption = 'Document No.'; }
                field(documentType; Rec."Document Type") { Caption = 'Document Type'; }

                // Account
                field(glAccountNo; Rec."G/L Account No.") { Caption = 'G/L Account No.'; }

                // Amounts
                field(amount; Rec.Amount) { Caption = 'Amount'; }
                field(debitAmount; Rec."Debit Amount") { Caption = 'Debit Amount'; }
                field(creditAmount; Rec."Credit Amount") { Caption = 'Credit Amount'; }

                // Dimensions (critical link)
                field(dimensionSetId; Rec."Dimension Set ID") { Caption = 'Dimension Set ID'; }   //mapping point

                // Additional useful fields
                field(description; Rec.Description) { Caption = 'Description'; }
                field(sourceCode; Rec."Source Code") { Caption = 'Source Code'; }
                field(businessUnitCode; Rec."Business Unit Code") { Caption = 'Business Unit Code'; }

                // Audit
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { Caption = 'Last Modified Date Time'; }
            }
        }
    }
}