tableextension 52116 "12E Sales Header" extends "Sales Header"
{
    trigger OnBeforeDelete()
    var
        SalesLine: Record "Sales Line";
        Setup: Record "12E Setup";
    begin
        Setup.Get();

        if not Setup."Enable CCD Process" then
            exit;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetFilter("12E CCD No.", '<>%1', '');

        if not SalesLine.IsEmpty() then
            Error(
                'Sales Invoice %1 cannot be deleted because it is attached to a Posted Contact Center Distribution document.',
                Rec."No.");
    end;
}
