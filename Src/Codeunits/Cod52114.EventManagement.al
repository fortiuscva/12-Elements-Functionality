codeunit 52114 "12E Event Management"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostPurchaseDoc, '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    var
        ElementsSetup: Record "12E Setup";
        CCDLocationMapping: Record "12E CCD Location Mapping";
    begin
        if not ElementsSetup.Get() then
            exit;

        if not ElementsSetup."Enable CCD Process" then
            exit;

        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Invoice then
            exit;

        CCDLocationMapping.Reset();
        CCDLocationMapping.SetRange("Location Code", PurchaseHeader."Location Code");
        CCDLocationMapping.SetRange("Processing Type", CCDLocationMapping."Processing Type"::Vendor);
        CCDLocationMapping.SetRange("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        if CCDLocationMapping.FindFirst() then begin
            PurchaseHeader.TestField("12E Period Start Date");
            PurchaseHeader.TestField("12E Period End Date");
            PurchaseHeader.TestField("12E Period Quantity");
        end;
    end;
}