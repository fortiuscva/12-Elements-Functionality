codeunit 52108 "12E CCD Mgmt"
{
    trigger OnRun()
    begin
        CreateCCDDocuments();
    end;

    procedure CreateCCDDocuments()
    var
        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
        PurchInvHeader: Record "Purch. Inv. Header";
        TwelveSetup: Record "12E Setup";
        ClientID: Integer;
    begin
        ClientID := GetClientID();

        QuestcoPayrollBatch.Reset();
        QuestcoPayrollBatch.SetCurrentKey("Client ID", "Batch ID");
        QuestcoPayrollBatch.SetRange("Client ID", ClientID);
        QuestcoPayrollBatch.SetRange("CCD No.", '');
        QuestcoPayrollBatch.SetRange("Posted CCD No.", '');

        if QuestcoPayrollBatch.FindSet(true) then
            repeat
                ProcessQuestcoPayrollBatch(QuestcoPayrollBatch);
            until QuestcoPayrollBatch.Next() = 0;

        TwelveSetup.Get();

        if not TwelveSetup."Process RDTJ Invoices" then
            exit;

        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("12E CCD No.", '');
        PurchInvHeader.SetRange("12E Posted CCD No.", '');
        if PurchInvHeader.FindSet(true) then
            repeat
                ProcessPostedPurchaseInvoice(PurchInvHeader);
            until PurchInvHeader.Next() = 0;
    end;

    local procedure ProcessQuestcoPayrollBatch(var QuestcoPayrollBatch: Record "12E Questco Payroll Batch")
    var
        CCDHeader: Record "12E CCD Header";
        PayrollTotalHours: Decimal;
    begin
        QuestcoPayrollBatch.TestField("Client ID");
        QuestcoPayrollBatch.TestField("Batch ID");
        QuestcoPayrollBatch.TestField("Pay Period Start Date");
        QuestcoPayrollBatch.TestField("Pay Period End Date");

        if QuestcoPayrollBatch."Pay Period Start Date" > QuestcoPayrollBatch."Pay Period End Date" then
            Error(
                'Pay Period Start Date %1 cannot be later than Pay Period End Date %2 for Batch %3.',
                QuestcoPayrollBatch."Pay Period Start Date",
                QuestcoPayrollBatch."Pay Period End Date",
                QuestcoPayrollBatch."Batch ID");

        PayrollTotalHours := GetPayrollBatchHours(QuestcoPayrollBatch."Client ID", QuestcoPayrollBatch."Batch ID");

        Clear(CCDHeader);
        CCDHeader.Init();
        CCDHeader.Insert(true);

        CCDHeader."Payroll Batch ID" := QuestcoPayrollBatch."Batch ID";
        CCDHeader."Period Start Date" := QuestcoPayrollBatch."Pay Period Start Date";
        CCDHeader."Period End Date" := QuestcoPayrollBatch."Pay Period End Date";

        CCDHeader.Modify(true);

        CreateCCDLines(CCDHeader, QuestcoPayrollBatch, PayrollTotalHours);

        QuestcoPayrollBatch.Modify(true);
    end;

    local procedure ProcessPostedPurchaseInvoice(var PurchInvHeader: Record "Purch. Inv. Header")
    var
        CCDHeader: Record "12E CCD Header";
        CCDLocationMapping: Record "12E CCD Location Mapping";
        LinesCreated: Boolean;
    begin
        PurchInvHeader.TestField("No.");
        PurchInvHeader.TestField("12E Period Start Date");
        PurchInvHeader.TestField("12E Period End Date");

        if PurchInvHeader."12E Period Start Date" > PurchInvHeader."12E Period End Date" then
            Error(
                'Period Start Date %1 cannot be later than Period End Date %2 for Posted Purchase Invoice %3.',
                PurchInvHeader."12E Period Start Date",
                PurchInvHeader."12E Period End Date",
                PurchInvHeader."No.");

        CCDLocationMapping.Reset();
        CCDLocationMapping.SetRange("Vendor No.", PurchInvHeader."Buy-from Vendor No.");
        CCDLocationMapping.SetRange(Blocked, false);
        CCDLocationMapping.SetRange("Processing Type", CCDLocationMapping."Processing Type"::Vendor);

        if not CCDLocationMapping.FindSet() then
            exit;

        Clear(CCDHeader);
        CCDHeader.Init();
        CCDHeader.Insert(true);

        CCDHeader."Invoice No." := PurchInvHeader."No.";
        CCDHeader."Period Start Date" := PurchInvHeader."12E Period Start Date";
        CCDHeader."Period End Date" := PurchInvHeader."12E Period End Date";

        CCDHeader.Modify(true);

        repeat
            if CreateVendorCCDLines(CCDHeader, PurchInvHeader, CCDLocationMapping."Location Code") then
                LinesCreated := true;
        until CCDLocationMapping.Next() = 0;

        if not LinesCreated then
            Error(
                'No Call Center Distribution data was found for Posted Purchase Invoice %1 for period %2 to %3.',
                PurchInvHeader."No.",
                PurchInvHeader."12E Period Start Date",
                PurchInvHeader."12E Period End Date");

        PurchInvHeader.Modify(true);
    end;

    local procedure CreateCCDLines(var CCDHeader: Record "12E CCD Header"; QuestcoPayrollBatch: Record "12E Questco Payroll Batch"; PayrollTotalHours: Decimal)
    var
        CCDQuery: Query "12E CCD Allocation Data";
        CCDLocationMapping: Record "12E CCD Location Mapping";
        PortfolioHandleTime: Decimal;
        TotalLocationHandleTime: Decimal;
        AllocationPercentage: Decimal;
        LinesCreated: Boolean;
    begin
        CCDQuery.SetRange(CallDate, QuestcoPayrollBatch."Pay Period Start Date", QuestcoPayrollBatch."Pay Period End Date");
        CCDQuery.Open();

        while CCDQuery.Read() do begin
            PortfolioHandleTime := CCDQuery.TotalHandleTime;

            TotalLocationHandleTime := GetLocationTotal(
                QuestcoPayrollBatch."Pay Period Start Date",
                QuestcoPayrollBatch."Pay Period End Date",
                CCDQuery.LocationCode);

            if TotalLocationHandleTime = 0 then
                Error(
                    'Total Handling Time is zero for Location %1 for payroll period %2 to %3.',
                    CCDQuery.LocationCode,
                    QuestcoPayrollBatch."Pay Period Start Date",
                    QuestcoPayrollBatch."Pay Period End Date");

            AllocationPercentage := Round((PortfolioHandleTime / TotalLocationHandleTime) * 100, 0.00001);

            if not CCDLocationMapping.Get(CCDQuery.LocationCode) then
                Error('CCD Location Mapping does not exist for Location %1.', CCDQuery.LocationCode);

            if CCDLocationMapping.Blocked then
                Error('CCD Location Mapping for Location %1 is blocked.', CCDQuery.LocationCode);

            if CCDLocationMapping."Processing Type" = CCDLocationMapping."Processing Type"::Payroll then begin
                CreatePayrollCCDLine(
                    CCDHeader,
                    QuestcoPayrollBatch,
                    CCDQuery.LocationCode,
                    CCDQuery.Portfolio,
                    PortfolioHandleTime,
                    AllocationPercentage,
                    PayrollTotalHours);

                LinesCreated := true;
            end;
        end;

        CCDQuery.Close();

        if not LinesCreated then
            Error(
                'No Call Center Distribution data was found for payroll Batch %1 for period %2 to %3.',
                QuestcoPayrollBatch."Batch ID",
                QuestcoPayrollBatch."Pay Period Start Date",
                QuestcoPayrollBatch."Pay Period End Date");
    end;

    local procedure CreatePayrollCCDLine(
        CCDHeader: Record "12E CCD Header";
        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
        LocationCode: Code[10];
        Portfolio: Code[20];
        PortfolioHandleTime: Decimal;
        AllocationPercentage: Decimal;
        PayrollTotalHours: Decimal)
    begin
        if PayrollTotalHours = 0 then
            Error(
                'Payroll hours are zero for Client ID %1, Batch ID %2.',
                QuestcoPayrollBatch."Client ID",
                QuestcoPayrollBatch."Batch ID");

        InsertCCDLine(
            CCDHeader,
            QuestcoPayrollBatch."Pay Period Start Date",
            LocationCode,
            Portfolio,
            PortfolioHandleTime,
            AllocationPercentage,
            PayrollTotalHours,
            QuestcoPayrollBatch."Batch ID",
            QuestcoPayrollBatch."Pay Period Start Date",
            QuestcoPayrollBatch."Pay Period End Date",
            '',
            0D);
    end;

    local procedure CreateVendorCCDLines(
        CCDHeader: Record "12E CCD Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        LocationCode: Code[10]): Boolean
    var
        CCDQuery: Query "12E CCD Allocation Data";
        CCDLocationMapping: Record "12E CCD Location Mapping";
        PortfolioHandleTime: Decimal;
        TotalLocationHandleTime: Decimal;
        AllocationPercentage: Decimal;
        InvoiceHours: Decimal;
        LinesCreated: Boolean;
    begin
        if not CCDLocationMapping.Get(LocationCode) then
            Error('CCD Location Mapping does not exist for Location %1.', LocationCode);

        if CCDLocationMapping.Blocked then
            exit(false);

        CCDLocationMapping.TestField("Vendor No.");

        if CCDLocationMapping."Vendor No." <> PurchInvHeader."Buy-from Vendor No." then
            exit(false);

        InvoiceHours := GetPurchaseInvoiceHours(PurchInvHeader."No.");

        if InvoiceHours = 0 then
            exit(false);

        CCDQuery.SetRange(CallDate, PurchInvHeader."12E Period Start Date", PurchInvHeader."12E Period End Date");
        CCDQuery.Open();

        while CCDQuery.Read() do begin
            if CCDQuery.LocationCode = LocationCode then begin
                PortfolioHandleTime := CCDQuery.TotalHandleTime;

                TotalLocationHandleTime := GetLocationTotal(
                    PurchInvHeader."12E Period Start Date",
                    PurchInvHeader."12E Period End Date",
                    LocationCode);

                if TotalLocationHandleTime = 0 then
                    Error(
                        'Total Handling Time is zero for Location %1 for period %2 to %3.',
                        LocationCode,
                        PurchInvHeader."12E Period Start Date",
                        PurchInvHeader."12E Period End Date");

                AllocationPercentage := Round((PortfolioHandleTime / TotalLocationHandleTime) * 100, 0.00001);

                InsertCCDLine(
                    CCDHeader,
                    PurchInvHeader."12E Period Start Date",
                    LocationCode,
                    CCDQuery.Portfolio,
                    PortfolioHandleTime,
                    AllocationPercentage,
                    InvoiceHours,
                    0,
                    PurchInvHeader."12E Period Start Date",
                    PurchInvHeader."12E Period End Date",
                    PurchInvHeader."No.",
                    PurchInvHeader."Posting Date");

                LinesCreated := true;
            end;
        end;

        CCDQuery.Close();

        exit(LinesCreated);
    end;

    local procedure GetPurchaseInvoiceHours(PurchaseInvoiceNo: Code[20]): Decimal
    var
        PurchInvLine: Record "Purch. Inv. Line";
        InvoiceHours: Decimal;
    begin
        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document No.", PurchaseInvoiceNo);

        if PurchInvLine.FindSet() then
            repeat
                InvoiceHours += PurchInvLine.Quantity;
            until PurchInvLine.Next() = 0;

        exit(InvoiceHours);
    end;

    local procedure GetPayrollBatchHours(ClientID: Integer; BatchID: Integer): Decimal
    var
        CCDPayrollQuery: Query "12E CCD Payroll Data";
        TotalHours: Decimal;
        DeptCode: Code[20];
    begin
        DeptCode := GetDepartmentCode();

        CCDPayrollQuery.SetRange(ClientID, ClientID);
        CCDPayrollQuery.SetRange(BatchIDFilter, BatchID);
        CCDPayrollQuery.SetRange(Department, DeptCode);
        CCDPayrollQuery.Open();

        while CCDPayrollQuery.Read() do
            TotalHours += CCDPayrollQuery.TotalHoursWorked;

        CCDPayrollQuery.Close();

        exit(TotalHours);
    end;

    local procedure GetLocationTotal(PayPeriodStartDate: Date; PayPeriodEndDate: Date; LocationCode: Code[10]): Decimal
    var
        LocationQuery: Query "12E CCD Location Totals";
        TotalLocationHandleTime: Decimal;
    begin
        LocationQuery.SetRange(CallDate, PayPeriodStartDate, PayPeriodEndDate);
        LocationQuery.SetRange(LocationCode, LocationCode);
        LocationQuery.Open();

        if LocationQuery.Read() then
            TotalLocationHandleTime := LocationQuery.TotalHandleTime;

        LocationQuery.Close();

        exit(TotalLocationHandleTime);
    end;

    local procedure InsertCCDLine(
        CCDHeader: Record "12E CCD Header";
        CallDate: Date;
        LocationCode: Code[10];
        Portfolio: Code[20];
        PortfolioHandleTime: Decimal;
        AllocationPercentage: Decimal;
        Hours: Decimal;
        PayrollBatchID: Integer;
        PayrollStartDate: Date;
        PayrollEndDate: Date;
        PurchaseInvoiceNo: Code[20];
        PurchaseInvoiceDate: Date)
    var
        CCDLine: Record "12E CCD Line";
        DistributedHours: Decimal;
    begin
        DistributedHours := Round(Hours * AllocationPercentage / 100, 0.00001);

        CCDLine.Init();
        CCDLine."Document No." := CCDHeader."No.";
        CCDLine."Line No." := GetNextLineNo(CCDHeader."No.");
        CCDLine."Location Code" := LocationCode;
        CCDLine.Portfolio := Portfolio;
        CCDLine."Handling Time" := PortfolioHandleTime;
        CCDLine.Percentage := AllocationPercentage;
        CCDLine."No. of Hours" := Hours;
        CCDLine."Distributed Quantity" := DistributedHours;
        CCDLine."Batch or Inv. Hours" := Hours;
        CCDLine."Batch or Inv. Percentage" := AllocationPercentage;

        if PayrollBatchID <> 0 then begin
            CCDLine."Payroll Batch ID" := PayrollBatchID;
            CCDLine."Period Start Date" := PayrollStartDate;
            CCDLine."Period End Date" := PayrollEndDate;
        end;

        if PurchaseInvoiceNo <> '' then
            CCDLine."Invoice No." := PurchaseInvoiceNo;

        CCDLine.Insert(true);
    end;

    local procedure GetNextLineNo(DocumentNo: Code[20]): Integer
    var
        CCDLine: Record "12E CCD Line";
    begin
        CCDLine.Reset();
        CCDLine.SetRange("Document No.", DocumentNo);

        if CCDLine.FindLast() then
            exit(CCDLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetClientID(): Integer
    var
        CompanyMapping: Record "12E Company Mapping";
        ClientID: Integer;
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyName);
        CompanyMapping.SetRange(Blocked, false);

        if not CompanyMapping.FindFirst() then
            Error('Company Mapping does not exist for company %1.', CompanyName);

        CompanyMapping.TestField("Client ID");
        ClientID := CompanyMapping."Client ID";

        if CompanyMapping.Next() <> 0 then
            Error('Multiple active Company Mappings exist for company %1.', CompanyName);

        exit(ClientID);
    end;

    local procedure GetDepartmentCode(): Code[20]
    var
        DepartmentCode: Record "12E Department Code";
    begin
        DepartmentCode.Reset();
        DepartmentCode.SetRange("Contact Center", true);

        if DepartmentCode.FindFirst() then
            exit(DepartmentCode.Code);
    end;
}