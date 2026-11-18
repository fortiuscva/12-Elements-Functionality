tableextension 52123 "12E Bank Account Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(52100; "12E Banking PKID"; Code[20])
        {
            Caption = 'Banking PK ID';
            DataClassification = CustomerContent;
            TableRelation = "12E Banking Transaction".PKID;
        }
    }
}
