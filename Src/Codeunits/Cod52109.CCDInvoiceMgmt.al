codeunit 52109 "12E CCD Invoice Mgmt"
{
    procedure CreateInvoices(var CCDHeader: Record "12E CC Distribution Header")
    var
        CCDLine: Record "12E CC Distribution Line";
        PortfolioMapping: Record "12E CC Portfolio Mapping";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LastCustomerNo: Code[20];
        CurrentInvoiceNo: Code[20];
        LineNo: Integer;
    begin
        if CCDHeader.Status <> CCDHeader.Status::Released then
            Error('Document must be Released before creating invoices.');

        CCDLine.Reset();
        CCDLine.SetRange("Document No.", CCDHeader."No.");
        CCDLine.SetFilter("Sales Invoice No.", '<>%1', '');

        if not CCDLine.IsEmpty() then
            Error('Invoices have already been created for document %1.', CCDHeader."No.");

        CCDLine.Reset();
        CCDLine.SetRange("Document No.", CCDHeader."No.");

        if CCDLine.FindSet(true) then
            repeat
                PortfolioMapping.Reset();
                PortfolioMapping.SetRange(Portfolio, CCDLine.Portfolio);
                PortfolioMapping.SetRange(Company, CompanyName());

                if not PortfolioMapping.FindFirst() then
                    Error(
                        'Portfolio Mapping does not exist for Portfolio %1 and Company %2.',
                        CCDLine.Portfolio,
                        CompanyName());

                if LastCustomerNo <> PortfolioMapping."Customer No." then begin
                    Clear(SalesHeader);

                    SalesHeader.Init();
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                    SalesHeader.Insert(true);

                    SalesHeader.Validate("Sell-to Customer No.", PortfolioMapping."Customer No.");
                    SalesHeader.Modify(true);

                    CurrentInvoiceNo := SalesHeader."No.";
                    LastCustomerNo := PortfolioMapping."Customer No.";
                    LineNo := 0;
                end;

                LineNo += 10000;

                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine."Document No." := CurrentInvoiceNo;
                SalesLine."Line No." := LineNo;

                SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                SalesLine.Validate("No.", PortfolioMapping."G/L Account No.");
                SalesLine.Validate(Quantity, 1);

                SalesLine.Description :=
                    StrSubstNo(
                        '%1 - %2 - %3',
                        CCDLine."Location Code",
                        CCDLine.Portfolio,
                        Format(CCDLine."CCD Date"));

                SalesLine.Insert(true);

                CCDLine."Sales Invoice No." := SalesLine."Document No.";
                CCDLine."Sales Invoice Line No." := SalesLine."Line No.";
                CCDLine.Modify();

            until CCDLine.Next() = 0;

        Message('Invoices created successfully.');
    end;
}