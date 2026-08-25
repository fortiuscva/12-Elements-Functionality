page 52162 "12E Lead Provider Lookup"
{
    ApplicationArea = All;
    Caption = 'Lead Provider Lookup';
    PageType = List;
    SourceTable = "12E Lead Provider Lookup";
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Lead Provider"; Rec."Lead Provider")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure LoadProviders(DataSourceID: Integer)
    var
        LeadSource: Record "12E Lead Source Reconciliation";
        ProviderLookup: Record "12E Lead Provider Lookup";
    begin
        Rec.Reset();
        Rec.DeleteAll();

        LeadSource.Reset();
        LeadSource.SetRange("Datasource ID", DataSourceID);

        if LeadSource.FindSet() then
            repeat
                if LeadSource."Lead Provider" <> '' then begin
                    ProviderLookup.Reset();
                    ProviderLookup.SetRange("Lead Provider", LeadSource."Lead Provider");

                    if not ProviderLookup.FindFirst() then begin
                        Rec.Init();
                        Rec."Lead Provider" := LeadSource."Lead Provider";
                        if Rec.Insert() then;
                    end;
                end;
            until LeadSource.Next() = 0;

        Rec.Reset();
    end;

    procedure GetSelectedProvider(): Text[100]
    begin
        exit(Rec."Lead Provider");
    end;
}
