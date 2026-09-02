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

    procedure CheckDataSourceID(DatasourceIDPar: Integer)
    begin
        CompanyMappingRecGbl.Reset();
        CompanyMappingRecGbl.SetRange("DataSource ID", DatasourceIDPar);
        if CompanyMappingRecGbl.FindLast() then begin
            if CompanyMappingRecGbl.Company = '' then
                Error(StrSubstNo(DatasourceIdMappingErrLbl, DatasourceIDPar));
        end else
            Error(StrSubstNo(DatasourceIdErrLbl, DatasourceIDPar));
    end;

    var

        CompanyMappingRecGbl: Record "12E Company Mapping";
        PortfolioErrLbl: Label 'Portfolio %1 does not exist in Company Mapping';
        PortfolioMappingErrLbl: Label 'Company Mapping does not exist for this portfolio %1';
        DatasourceIdErrLbl: Label 'Datasource ID %1 does not exist in Company Mapping';
        DatasourceIdMappingErrLbl: Label 'Company mapping does not exist for this Datasource %1';
}
