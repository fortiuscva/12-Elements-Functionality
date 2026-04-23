enum 52103 "12E EPIC Payment Status"
{
    Extensible = true;
    
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "None")
    {
        Caption = 'None';
    }
    value(2; Checked)
    {
        Caption = 'Checked';
    }
    value(3; Pending)
    {
        Caption = 'Pending';
    }
    value(4; Rejected)
    {
        Caption = 'Rejected';
    }
}
