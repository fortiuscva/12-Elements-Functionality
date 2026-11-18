tableextension 52122 "12E Gen. Journal Line" extends "Gen. Journal Line"
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
