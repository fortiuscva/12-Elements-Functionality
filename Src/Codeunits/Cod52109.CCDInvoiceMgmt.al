codeunit 52109 "12E CCD Invoice Mgmt"
{
    procedure CreateInvoices(var CCDHeader: Record "12E CCD Header")
    var
        CCDLine: Record "12E CCD Line";
        PortfolioMapping: Record "12E CCD Port. Cust. Mapping";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TwelveElementsSetup: Record "12E Setup";
    begin
        if CCDHeader.Status <> CCDHeader.Status::Released then
            Error('Document must be Released before creating invoices.');

        TwelveElementsSetup.Get();
        TwelveElementsSetup.TestField("CCD G/L Account No.");

        CCDLine.Reset();
        CCDLine.SetRange("Document No.", CCDHeader."No.");

        if CCDLine.FindSet() then
            repeat
                PortfolioMapping.Reset();
                PortfolioMapping.SetRange(Portfolio, CCDLine.Portfolio);

                if not PortfolioMapping.FindFirst() then
                    Error(
                        'Portfolio Mapping does not exist for Portfolio %1.',
                        CCDLine.Portfolio);

                Clear(SalesHeader);
                SalesHeader.Init();
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader.Insert(true);

                SalesHeader.Validate("Sell-to Customer No.", PortfolioMapping."Customer No.");
                SalesHeader.Modify(true);

                Clear(SalesLine);
                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := 10000;

                SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                SalesLine.Validate("No.", TwelveElementsSetup."CCD G/L Account No.");
                SalesLine.Validate(Quantity, CCDLine."Distributed Quantity");

                SalesLine.Description := StrSubstNo('%1 - %2 - %3', CCDLine."Location Code", CCDLine.Portfolio, Format(CCDLine."Call Date"));

                SalesLine.Validate("12E CCD No.", CCDHeader."No.");
                SalesLine.Validate("12E CCD Line No.", CCDLine."Line No.");
                SalesLine.Insert(true);

            until CCDLine.Next() = 0;

        Message('Sales Invoices created successfully.');
    end;
}