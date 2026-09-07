codeunit 52135 "12E Validations"
{
    procedure CheckPortfolioMapping(PortfolioPar: Text[30])
    begin
        CompanyMappingRecGbl.Reset();
        CompanyMappingRecGbl.SetRange(Portfolio, PortfolioPar);
        if CompanyMappingRecGbl.FindLast() then begin
            if CompanyMappingRecGbl.Company = '' then
                Error(StrSubstNo(PortfolioMappingErrLbl, PortfolioPar));
        end else
            Error(StrSubstNo(PortfolioErrLbl, PortfolioPar));
    end;

    procedure CheckDataSourceIDMapping(DatasourceIDPar: Integer)
    begin
        CompanyMappingRecGbl.Reset();
        CompanyMappingRecGbl.SetRange("DataSource ID", DatasourceIDPar);
        if CompanyMappingRecGbl.FindLast() then begin
            if CompanyMappingRecGbl.Company = '' then
                Error(StrSubstNo(DatasourceIdMappingErrLbl, DatasourceIDPar));
        end else
            Error(StrSubstNo(DatasourceIdErrLbl, DatasourceIDPar));
    end;

    procedure CheckQuestcoClientIDMapping(ClientIDPar: Integer)
    begin
        CompanyMappingRecGbl.Reset();
        CompanyMappingRecGbl.SetRange("Client ID", ClientIDPar);
        if CompanyMappingRecGbl.FindLast() then begin
            if CompanyMappingRecGbl.Company = '' then
                Error(StrSubstNo(QuestcoClientIdMappingErrLbl, ClientIDPar));
        end else
            Error(StrSubstNo(QuestcoClientIdErrLbl, ClientIDPar));
    end;

    procedure CheckWhetherPayrollBatchExists(ClientIDPar: Integer; BatchIDPar: Integer)
    var
        PayrollBatch: Record "12E Questco Payroll Batch";
    begin
        PayrollBatch.Reset();
        PayrollBatch.SetRange("Client ID", ClientIDPar);
        PayrollBatch.SetRange("Batch ID", BatchIDPar);
        if PayrollBatch.IsEmpty() then
            Error(StrSubstNo(PayrollBatchDoesNotExistErrLbl, ClientIDPar, BatchIDPar));
    end;

    var

        CompanyMappingRecGbl: Record "12E Company Mapping";
        PortfolioErrLbl: Label 'Portfolio %1 does not exist in company mapping.';
        PortfolioMappingErrLbl: Label 'Portfolio %1 is not associated with any company.';
        DatasourceIdErrLbl: Label 'Datasource ID %1 does not exist in company mapping.';
        DatasourceIdMappingErrLbl: Label 'Datasource ID %1 is not associated with any company.';
        QuestcoClientIdErrLbl: Label 'Questco Client ID %1 does not exist in company mapping.';
        QuestcoClientIdMappingErrLbl: Label 'Questco Client ID %1 is not associated with any company.';
        PayrollBatchDoesNotExistErrLbl: Label 'Questco Payroll Batch does not exist with this Client ID  %1 and Batch ID %2.';
}
