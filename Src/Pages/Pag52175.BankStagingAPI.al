page 52175 "12E Bank Staging API"
{
    APIGroup = '12Elements';
    APIPublisher = '12Elements';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'BankStagingAPI';
    DelayedInsert = true;
    EntityName = 'BankStagingRecords';
    EntitySetName = 'BankStagingRecords';
    PageType = API;
    SourceTable = "12E Bank Staging";

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
                field(datasourceID; Rec."Datasource ID")
                {
                    Caption = 'Datasource ID';
                }
                field(portfolio; Rec.Portfolio)
                {
                    Caption = 'Portfolio';
                }
                field(ddaAccount; Rec.DdaAccount)
                {
                    Caption = 'Bank Account No.';
                }
                field(transactionDate; Rec."Transaction Date")
                {
                    Caption = 'Transaction Date';
                }
                field(transactionDescription; Rec."Transaction Description")
                {
                    Caption = 'Transaction Description';
                }
                field(checkNo; Rec."Check No.")
                {
                    Caption = 'Check No.';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(currentBalance; Rec."Current Balance")
                {
                    Caption = 'Current Balance';
                }
            }
        }
    }
}
