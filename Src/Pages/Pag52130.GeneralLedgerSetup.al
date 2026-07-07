page 52130 "12E General Ledger Setup"
{
    PageType = API;
    SourceTable = "General Ledger Setup";
    APIPublisher = '12Elements';
    APIGroup = '12Elements';
    APIVersion = 'v2.0';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    EntityName = 'generalLedgerSetup';
    EntitySetName = 'generalLedgerSetup';
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // System
                field(id; Rec.SystemId) { Caption = 'Id'; }

                // Dimensions
                field(globalDimension1Code; Rec."Global Dimension 1 Code") { Caption = 'Global Dimension 1 Code'; }
                field(globalDimension2Code; Rec."Global Dimension 2 Code") { Caption = 'Global Dimension 2 Code'; }
                // Shortcut Dimensions 3–8
                field(shortcutDimension3Code; Rec."Shortcut Dimension 3 Code") { Caption = 'Shortcut Dimension 3 Code'; }
                field(shortcutDimension4Code; Rec."Shortcut Dimension 4 Code") { Caption = 'Shortcut Dimension 4 Code'; }
                field(shortcutDimension5Code; Rec."Shortcut Dimension 5 Code") { Caption = 'Shortcut Dimension 5 Code'; }
                field(shortcutDimension6Code; Rec."Shortcut Dimension 6 Code") { Caption = 'Shortcut Dimension 6 Code'; }
                field(shortcutDimension7Code; Rec."Shortcut Dimension 7 Code") { Caption = 'Shortcut Dimension 7 Code'; }
                field(shortcutDimension8Code; Rec."Shortcut Dimension 8 Code") { Caption = 'Shortcut Dimension 8 Code'; }


                // Local currency
                field(lcyCode; Rec."LCY Code") { Caption = 'LCY Code'; }

                // Posting setup (optional but useful)
                field(allowPostingFrom; Rec."Allow Posting From") { Caption = 'Allow Posting From'; }
                field(allowPostingTo; Rec."Allow Posting To") { Caption = 'Allow Posting To'; }
            }
        }
    }
}