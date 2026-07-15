tableextension 52102 "12E Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(52100; "12E CCD No."; Code[20])
        {
            Caption = 'CCD No.';
            DataClassification = CustomerContent;
        }
        field(52101; "12E CCD Line No."; Integer)
        {
            Caption = 'CCD Line No.';
            DataClassification = CustomerContent;
        }
    }
}
