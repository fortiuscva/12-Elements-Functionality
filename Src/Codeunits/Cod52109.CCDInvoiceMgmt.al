codeunit 52109 "12E CCD Invoice Mgmt"
{
    procedure PostandCreateInvoices(var CCDHeader: Record "12E CCD Header")
    var
        CCDLine: Record "12E CCD Line";
        PortfolioMapping: Record "12E CCD Port. Cust. Mapping";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TwelveElementsSetup: Record "12E Setup";
        PostedCCDHeader: Record "12E Posted CCD Header";
        PostedCCDLine: Record "12E Posted CCD Line";
        CurrentPortfolio: Code[20];
        CurrentLocation: Code[20];
        Qty: Decimal;
        NextLineNo: Integer;
    begin
        CCDHeader.TestField(Status, CCDHeader.Status::Released);

        PostedCCDHeader.Init();
        PostedCCDHeader.TransferFields(CCDHeader);
        PostedCCDHeader.Insert(true);

        TwelveElementsSetup.Get();
        TwelveElementsSetup.TestField("CCD G/L Account No.");

        CCDLine.Reset();
        CCDLine.SetCurrentKey(Portfolio, "Location Code");
        CCDLine.SetRange("Document No.", CCDHeader."No.");

        if not CCDLine.FindSet() then
            exit;
        repeat
            PostedCCDLine.Init();
            PostedCCDLine.TransferFields(CCDLine);
            PostedCCDLine.Insert(true);

            if (CurrentPortfolio <> CCDLine.Portfolio) or
               (CurrentLocation <> CCDLine."Location Code")
            then begin

                CurrentPortfolio := CCDLine.Portfolio;
                CurrentLocation := CCDLine."Location Code";

                PortfolioMapping.Get(CurrentPortfolio);

                Clear(SalesHeader);
                SalesHeader.Init();
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader.Insert(true);

                SalesHeader.Validate("Sell-to Customer No.", PortfolioMapping."Customer No.");
                SalesHeader.Modify(true);

                NextLineNo := 10000;
            end;

            Qty := CCDLine."Distributed Quantity";

            SalesLine.Init();
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := NextLineNo;

            SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
            SalesLine.Validate("No.", TwelveElementsSetup."CCD G/L Account No.");
            SalesLine.Validate(Quantity, Qty);

            SalesLine.Description :=
                StrSubstNo(
                    '%1 - %2 - %3 - %4',
                    CCDLine."Location Code",
                    CCDLine.Portfolio,
                    Format(CCDLine."Period Start Date"), Format(CCDLine."Period End Date"));

            SalesLine.Validate("12E CCD No.", CCDHeader."No.");
            SalesLine.Validate("12E CCD Line No.", CCDLine."Line No.");
            SalesLine.Insert(true);

            NextLineNo += 10000;

        until CCDLine.Next() = 0;


        CCDHeader.Delete(true);

        Message('Posted contact center distribution document &\Sales Invoices were created successfully.');
    end;
}