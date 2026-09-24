page 52162 "12E Lead Vendor Lookup"
{
    ApplicationArea = All;
    Caption = 'Lead Vendor Lookup';
    PageType = List;
    SourceTable = "12E Lead Vendor Lookup";
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
                field("Lead Vendor"; Rec."Lead Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Vendor field', Comment = '%';
                }
            }
        }
    }

    procedure LoadProviders(DataSourceID: Integer)
    var
        LeadSource: Record "12E Lead Source Reconciliation";
        ProviderLookup: Record "12E Lead Vendor Lookup";
    begin
        Rec.Reset();
        Rec.DeleteAll();

        LeadSource.Reset();
        LeadSource.SetRange("Datasource ID", DataSourceID);

        if LeadSource.FindSet() then
            repeat
                if LeadSource."Lead Vendor" <> '' then begin
                    ProviderLookup.Reset();
                    ProviderLookup.SetRange("Lead Vendor", LeadSource."Lead Vendor");

                    if not ProviderLookup.FindFirst() then begin
                        Rec.Init();
                        Rec."Lead Vendor" := LeadSource."Lead Vendor";
                        if Rec.Insert() then;
                    end;
                end;
            until LeadSource.Next() = 0;

        Rec.Reset();
    end;

    procedure GetSelectedProvider(): Text[100]
    begin
        exit(Rec."Lead Vendor");
    end;
}
