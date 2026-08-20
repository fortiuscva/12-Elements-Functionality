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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeUpdateGLReg', '', false, false)]
    local procedure OnBeforeUpdateGLReg(IsTransactionConsistent: Boolean; var IsGLRegInserted: Boolean; var GLReg: Record "G/L Register";
       var IsHandled: Boolean; var GenJnlLine: Record "Gen. Journal Line"; GlobalGLEntry: Record "G/L Entry"; FirstNewVATEntryNo: Integer; NextTaxEntryNo: Integer)
    begin
        if IsGLRegInserted then
            exit;

        HandleGLRegister(GenJnlLine, GLReg);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", OnReverseOnAfterFinishPosting, '', false, false)]
    local procedure "Gen. Jnl.-Post Reverse_OnReverseOnAfterFinishPosting"(var ReversalEntry2: Record "Reversal Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var GLRegister: Record "G/L Register"; GLRegister2: Record "G/L Register")
    begin
        HandleReversal(ReversalEntry2);
    end;

    local procedure HandleGLRegister(GenJnlLine: Record "Gen. Journal Line"; GLReg: Record "G/L Register")
    begin
        if TryUpdatePayroll(GenJnlLine, GLReg) then
            exit;

        if TryUpdateLoyalty(GenJnlLine, GLReg) then
            exit;
    end;

    local procedure TryUpdatePayroll(GenJnlLine: Record "Gen. Journal Line"; GLReg: Record "G/L Register"): Boolean
    var
        PayrollBatchHeader: Record "12E Payroll Batch Header";
        TwelveElementsSetup: Record "12E Setup";
    begin
        TwelveElementsSetup.Get();

        if GenJnlLine."Journal Template Name" <> TwelveElementsSetup."Payroll Jnl. Template" then
            exit(false);

        if GenJnlLine."Journal Batch Name" <> TwelveElementsSetup."Payroll Jnl. Batch" then
            exit(false);

        if GenJnlLine."Document No." = '' then
            exit(false);

        PayrollBatchHeader.Reset();
        PayrollBatchHeader.SetRange("No.", GenJnlLine."Document No.");
        if not PayrollBatchHeader.FindFirst() then
            exit(false);

        PayrollBatchHeader."G/L Register No." := GLReg."No.";
        PayrollBatchHeader.Modify(true);

        exit(true);
    end;

    local procedure TryUpdateLoyalty(GenJnlLine: Record "Gen. Journal Line"; GLReg: Record "G/L Register"): Boolean
    var
        LoyaltyPoints: Record "12E Loyalty Points";
    begin
        if GenJnlLine."Source Code" <> GetLoyaltySourceCode() then
            exit(false);

        LoyaltyPoints.Reset();
        LoyaltyPoints.SetRange("Document No.", GenJnlLine."Document No.");
        LoyaltyPoints.SetRange(Processed, false);

        if not LoyaltyPoints.FindFirst() then
            exit(false);

        LoyaltyPoints."G/L Register No." := GLReg."No.";
        LoyaltyPoints.Modify(true);

        exit(true);
    end;

    local procedure GetLoyaltySourceCode(): Code[20]
    var
        TwelveSetup: Record "12E Setup";
    begin
        TwelveSetup.Get();
        exit(TwelveSetup."Loyalty Source Code");
    end;

    local procedure HandleReversal(var ReversalEntry: Record "Reversal Entry")
    begin
        if TryUpdatePayrollReversal(ReversalEntry) then
            exit;

        if TryUpdateLoyaltyReversal(ReversalEntry) then
            exit;
    end;

    local procedure TryUpdatePayrollReversal(var ReversalEntry: Record "Reversal Entry"): Boolean
    var
        PostedPayrollHeader: Record "12E Posted Payroll Header";
    begin
        PostedPayrollHeader.SetRange("G/L Register No.", ReversalEntry."G/L Register No.");
        if not PostedPayrollHeader.FindFirst() then
            exit(false);

        PostedPayrollHeader.Reversed := true;
        PostedPayrollHeader.Modify(true);

        exit(true);
    end;

    local procedure TryUpdateLoyaltyReversal(var ReversalEntry: Record "Reversal Entry"): Boolean
    var
        LoyaltyPoints: Record "12E Loyalty Points";
    begin
        LoyaltyPoints.SetRange("G/L Register No.", ReversalEntry."G/L Register No.");
        if not LoyaltyPoints.FindFirst() then
            exit(false);

        LoyaltyPoints.Reversed := true;
        LoyaltyPoints.Modify(true);

        exit(true);
    end;
}