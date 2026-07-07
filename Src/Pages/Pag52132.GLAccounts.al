page 52132 "12E GL Accounts"
{
    PageType = API;
    SourceTable = "G/L Account";
    APIPublisher = '12Elements';
    APIGroup = '12Elements';
    APIVersion = 'v2.0';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    EntityName = 'glAccount';
    EntitySetName = 'glAccounts';
    ODataKeyFields = SystemId;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; }
                field(glAccountNo; Rec."No.") { Caption = 'Number'; }
                field(name; Rec.Name) { Caption = 'Name'; }
                field(accountType; Rec."Account Type") { Caption = 'Account Type'; }
                field(incomeBalance; Rec."Income/Balance") { Caption = 'Income/Balance'; }
                field(accountCategory; Rec."Account Category") { Caption = 'Account Category'; }
                //field(accountSubcategory; Rec.sub "Account Subcategory")                {                    Caption = 'Account Subcategory';                }
                field(blocked; Rec.Blocked) { Caption = 'Blocked'; }
                field(directPosting; Rec."Direct Posting") { Caption = 'Direct Posting'; }
                field(reconciliationAccount; Rec."Reconciliation Account") { Caption = 'Reconciliation Account'; }
                field(totaling; Rec.Totaling) { Caption = 'Totaling'; }
                field(indentation; Rec.Indentation) { Caption = 'Indentation'; }

                // Totals / rollups
                field(netChange; Rec."Net Change") { Caption = 'Net Change'; }
                field(balance; Rec.Balance) { Caption = 'Balance'; }
                field(debitAmount; Rec."Debit Amount") { Caption = 'Debit Amount'; }
                field(creditAmount; Rec."Credit Amount") { Caption = 'Credit Amount'; }


                field(lastModifiedDateTime; Rec.SystemModifiedAt) { Caption = 'Last Modified Date Time'; }
            }
        }
    }
}