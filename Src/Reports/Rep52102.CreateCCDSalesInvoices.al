report 52102 "12E Create CCD Sales Invoices"
{
    Caption = 'Create CCD Sales Invoices';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PostedCCDHeader; "12E Posted CCD Header")
        {
            DataItemTableView = sorting("No.");

            trigger OnAfterGetRecord()
            begin
                ProcessPostedCCD(PostedCCDHeader);
            end;
        }
    }

    var
        TwelveElementsSetup: Record "12E Setup";
        PortfolioMapping: Record "12E CCD Port. Cust. Mapping";
        TempCCDLine: Record "12E Posted CCD Line" temporary;
        SalesHeader: Record "Sales Header";
        SalesInvoicesCreated: Integer;
        SalesLinesCreated: Integer;

    trigger OnPreReport()
    begin
        GetSetup();
    end;

    trigger OnPostReport()
    begin
        if SalesInvoicesCreated = 0 then
            Message('No Sales Invoices were created.')
        else
            Message('Successfully Created %1 Sales Invoice(s)', SalesInvoicesCreated);
    end;

    local procedure GetSetup()
    begin
        TwelveElementsSetup.Get();
        TwelveElementsSetup.TestField("CCD G/L Account No.");
    end;

    local procedure ProcessPostedCCD(PostedCCDHeader: Record "12E Posted CCD Header")
    var
        PostedCCDLine: Record "12E Posted CCD Line";
        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
        PayDate: Date;
        SalesInvoiceNo: Code[20];
        NextLineNo: Integer;
    begin
        if PostedCCDHeader."Payroll Batch ID" <> 0 then begin
            QuestcoPayrollBatch.SetRange("Batch ID", PostedCCDHeader."Payroll Batch ID");
            QuestcoPayrollBatch.SetRange("Pay Period Start Date", PostedCCDHeader."Period Start Date");
            QuestcoPayrollBatch.SetRange("Pay Period End Date", PostedCCDHeader."Period End Date");

            if not QuestcoPayrollBatch.FindFirst() then
                Error('Payroll Batch %1 was not found.', PostedCCDHeader."Payroll Batch ID");

            QuestcoPayrollBatch.TestField("Pay Date");
            PayDate := QuestcoPayrollBatch."Pay Date";
        end;

        PostedCCDLine.Reset();
        PostedCCDLine.SetCurrentKey("Document No.", Portfolio, "Location Code");
        PostedCCDLine.SetRange("Document No.", PostedCCDHeader."No.");
        PostedCCDLine.SetRange("Billed By Partner", false);

        if not PostedCCDLine.FindSet() then
            exit;

        repeat
            if PostedCCDLine."Distributed Quantity" <> 0 then begin
                PostedCCDLine.CalcFields("Sales Invoice No.", "Pstd. Sales Invoice No.");

                if (PostedCCDLine."Sales Invoice No." = '') and
                   (PostedCCDLine."Pstd. Sales Invoice No." = '')
                then begin
                    SalesInvoiceNo := GetSalesInvoiceForPortfolio(PostedCCDLine.Portfolio);

                    if SalesInvoiceNo = '' then
                        SalesInvoiceNo := CreateSalesInvoice(PostedCCDLine.Portfolio, PayDate);

                    NextLineNo := GetNextSalesLineNo(SalesInvoiceNo);

                    CreateSalesInvoiceLine(PostedCCDHeader, PostedCCDLine, SalesInvoiceNo, NextLineNo);
                    SalesLinesCreated += 1;
                end;
            end;
        until PostedCCDLine.Next() = 0;
    end;

    local procedure GetSalesInvoiceForPortfolio(PortfolioCode: Text[30]): Code[20]
    begin
        TempCCDLine.Reset();
        TempCCDLine.SetRange(Portfolio, PortfolioCode);

        if TempCCDLine.FindFirst() then
            exit(TempCCDLine."Document No.");

        exit('');
    end;

    local procedure CreateSalesInvoice(PortfolioCode: Text[30]; PayDate: Date): Code[20]
    var
        CustomerNo: Code[20];
        SalesInvoiceNo: Code[20];
    begin
        PortfolioMapping.Reset();
        PortfolioMapping.SetRange(Portfolio, PortfolioCode);

        if not PortfolioMapping.FindFirst() then
            Error('Portfolio Customer Mapping does not exist for Portfolio %1.', PortfolioCode);

        PortfolioMapping.TestField("Customer No.");
        CustomerNo := PortfolioMapping."Customer No.";

        Clear(SalesHeader);
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Validate("External Document No.", ('CCD' + Format(PayDate, 0, '<Month,2><Day,2><Year4>')));
        SalesHeader.Validate("Posting Date", PayDate);
        SalesHeader.Modify(true);

        SalesInvoiceNo := SalesHeader."No.";

        TempCCDLine.Init();
        TempCCDLine.Portfolio := PortfolioCode;
        TempCCDLine."Document No." := SalesInvoiceNo;
        TempCCDLine.Insert();

        SalesInvoicesCreated += 1;

        exit(SalesInvoiceNo);
    end;

    local procedure CreateSalesInvoiceLine(PostedCCDHeader: Record "12E Posted CCD Header"; PostedCCDLine: Record "12E Posted CCD Line"; SalesInvoiceNo: Code[20]; LineNo: Integer)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
        SalesLine."Document No." := SalesInvoiceNo;
        SalesLine."Line No." := LineNo;

        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
        SalesLine.Validate("No.", TwelveElementsSetup."CCD G/L Account No.");
        SalesLine.Validate(Quantity, PostedCCDLine."Distributed Quantity");

        SalesLine.Description := StrSubstNo(
            '%1-Batch(%2)-(%3-%4)',
            PostedCCDLine."Location Code",
            Format(PostedCCDLine."Payroll Batch ID"),
            Format(PostedCCDHeader."Period Start Date"),
            Format(PostedCCDHeader."Period End Date"));

        SalesLine.Validate("12E CCD No.", PostedCCDHeader."No.");
        SalesLine.Validate("12E CCD Line No.", PostedCCDLine."Line No.");

        SalesLine.Insert(true);
    end;

    local procedure GetNextSalesLineNo(SalesInvoiceNo: Code[20]): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.SetRange("Document No.", SalesInvoiceNo);

        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);

        exit(10000);
    end;
}