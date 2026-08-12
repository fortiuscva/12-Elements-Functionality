tableextension 52116 "12E Sales Header" extends "Sales Header"
{
    trigger OnBeforeDelete()
    var
        SalesLine: Record "Sales Line";
        Setup: Record "12E Setup";
    begin
        if not Setup."CCD Process Enabled" then
            exit;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetFilter("12E CCD No.", '<>%1', '');
        SalesLine.SetFilter("12E CCD Line No.", '<>%1', 0);
        if not SalesLine.IsEmpty() then
            Error('Sales Invoice %1 cannot be deleted, as it is attached with a Posted Contact Center Distribution documents', Rec."No.");
    end;
}
