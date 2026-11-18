tableextension 52121 "Bank Acc. Reconciliation Line" extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        field(52100; "12E Banking PKID"; Code[20])
        {
            Caption = 'Banking PKID';
            DataClassification = CustomerContent;
            TableRelation = "12E Banking Transaction".PKID;
        }
    }
}
