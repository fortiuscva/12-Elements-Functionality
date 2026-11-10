page 52179 "12E Intg. RoleCenter"
{
    PageType = CardPart;
    SourceTable = "12E Intg. RoleCenter";
    ApplicationArea = All;
    Caption = 'Activities';

    layout
    {
        area(Content)
        {
            cuegroup("Contact Center Distribution")
            {
                Caption = 'Contact Center Distribution';

                field("CCD Documents"; Rec."CCD Documents")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDownPageId = "12E CCD Details";
                }

                field("Posted CCD Documents"; Rec."Posted CCD Documents")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDownPageId = "12E Posted CCD Details";
                }
            }

            cuegroup(Payroll)
            {
                Caption = 'Payroll';

                field("Payroll Documents"; Rec."Payroll Documents")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDownPageId = "12E Questco Payroll Documents";
                }

                field("Posted Payroll Documents"; Rec."Posted Payroll Documents")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDownPageId = "12E Posted Payroll Documents";
                }
            }

            cuegroup("LMS Transactions")
            {
                Caption = 'LMS Transactions';

                field("LMS Transaction Documents"; Rec."LMS Transaction Documents")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDownPageId = "12E LMS Transaction Documents";
                }

                field("Posted LMS Transc Documents"; Rec."Posted LMS Transc Documents")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDownPageId = "12E Posted LMS Trans.Documents";
                }
            }

            cuegroup(LoyaltyPoints)
            {
                Caption = 'Loyalty Points';

                field("Loyalty Points"; Rec."Loyalty Points")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        LoyaltyPoints: Record "12E Loyalty Points";
                        CompanyMapping: Record "12E Company Mapping";
                    begin
                        CompanyMapping.SetRange(Company, CompanyName());
                        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
                        if not CompanyMapping.FindFirst() then
                            exit;

                        LoyaltyPoints.SetRange(Portfolio, CompanyMapping.Portfolio);
                        LoyaltyPoints.SetRange("G/L Register No.", 0);

                        Page.Run(Page::"12E Loyalty Points", LoyaltyPoints);
                    end;
                }

                field("Posted Loyalty Points"; Rec."Posted Loyalty Points")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        LoyaltyPoints: Record "12E Loyalty Points";
                        CompanyMapping: Record "12E Company Mapping";
                    begin
                        CompanyMapping.SetRange(Company, CompanyName());
                        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
                        if not CompanyMapping.FindFirst() then
                            exit;

                        LoyaltyPoints.SetRange(Portfolio, CompanyMapping.Portfolio);
                        LoyaltyPoints.SetFilter("G/L Register No.", '<>%1', 0);

                        Page.Run(Page::"12E Loyalty Points", LoyaltyPoints);
                    end;
                }
            }

            cuegroup(LMSBatches)
            {
                Caption = 'LMS Batches';

                field("LMS Batches"; Rec."LMS Batches")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        LMSBatch: Record "12E LMS Batch";
                        CompanyMapping: Record "12E Company Mapping";
                    begin
                        CompanyMapping.SetRange(Company, CompanyName());
                        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
                        if not CompanyMapping.FindFirst() then
                            exit;

                        LMSBatch.SetRange("Datasource ID", CompanyMapping."DataSource ID");
                        LMSBatch.SetRange("G/L Register No.", 0);

                        Page.Run(Page::"12E LMS Batches", LMSBatch);
                    end;
                }

                field("Posted LMS Batches"; Rec."Posted LMS Batches")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        LMSBatch: Record "12E LMS Batch";
                        CompanyMapping: Record "12E Company Mapping";
                    begin
                        CompanyMapping.SetRange(Company, CompanyName());
                        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
                        if not CompanyMapping.FindFirst() then
                            exit;

                        LMSBatch.SetRange("Datasource ID", CompanyMapping."DataSource ID");
                        LMSBatch.SetFilter("G/L Register No.", '<>%1', 0);

                        Page.Run(Page::"12E LMS Batches", LMSBatch);
                    end;
                }
            }

            cuegroup(Customers)
            {
                Caption = 'Customers';

                field(Customer; Rec.Customer)
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        CustomerRec: Record Customer;
                    begin
                        Page.Run(Page::"Customer List", CustomerRec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get('12E Intg. RoleCenter') then begin
            Rec.Init();
            Rec."Primary Key" := '12E Intg. RoleCenter';
            Rec.Insert();
        end;

        CalculateDocumentCounts();
        Rec.Modify();
        CurrPage.Update(false);
    end;

    local procedure CalculateDocumentCounts(): Integer
    var
        FieldRef: FieldRef;
        CompanyMapping: Record "12E Company Mapping";
        CountValue: Integer;
    begin
        RecRef.Open(Database::"12E CCD Header");
        Rec."CCD Documents" := RecRef.Count();
        RecRef.Close();

        RecRef.Open(Database::"12E Posted CCD Header");
        Rec."Posted CCD Documents" := RecRef.Count();
        RecRef.Close();

        RecRef.Open(Database::"12E Payroll Batch Header");
        Rec."Payroll Documents" := RecRef.Count();
        RecRef.Close();

        RecRef.Open(Database::"12E Posted Payroll Header");
        Rec."Posted Payroll Documents" := RecRef.Count();
        RecRef.Close();

        RecRef.Open(Database::"12E LMS Transaction Header");
        Rec."LMS Transaction Documents" := RecRef.Count();
        RecRef.Close();

        RecRef.Open(Database::"12E Posted LMS Trans. Header");
        Rec."Posted LMS Transc Documents" := RecRef.Count();
        RecRef.Close();

        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
        if CompanyMapping.FindFirst() then begin
            RecRef.Open(Database::"12E Loyalty Points");

            FieldRef := RecRef.Field(3);
            FieldRef.SetRange(CompanyMapping.Portfolio);

            FieldRef := RecRef.Field(10);
            FieldRef.SetRange(0);

            Rec."Loyalty Points" := RecRef.Count();
            RecRef.Close();

            RecRef.Open(Database::"12E Loyalty Points");

            FieldRef := RecRef.Field(3);
            FieldRef.SetRange(CompanyMapping.Portfolio);

            FieldRef := RecRef.Field(10);
            FieldRef.SetFilter('<>%1', 0);

            Rec."Posted Loyalty Points" := RecRef.Count();
            RecRef.Close();
        end else begin
            Rec."Loyalty Points" := 0;
            Rec."Posted Loyalty Points" := 0;
        end;

        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
        if CompanyMapping.FindFirst() then begin
            RecRef.Open(Database::"12E LMS Batch");

            FieldRef := RecRef.Field(3);
            FieldRef.SetRange(CompanyMapping."DataSource ID");

            FieldRef := RecRef.Field(13);
            FieldRef.SetRange(0);

            Rec."LMS Batches" := RecRef.Count();
            RecRef.Close();

            RecRef.Open(Database::"12E LMS Batch");

            FieldRef := RecRef.Field(3);
            FieldRef.SetRange(CompanyMapping."DataSource ID");

            FieldRef := RecRef.Field(13);
            FieldRef.SetFilter('<>%1', 0);

            Rec."Posted LMS Batches" := RecRef.Count();
            RecRef.Close();
        end else begin
            Rec."LMS Batches" := 0;
            Rec."Posted LMS Batches" := 0;
        end;
        RecRef.Open(Database::Customer);
        Rec.Customer := RecRef.Count();
        RecRef.Close();

        CountValue := Rec."CCD Documents" + Rec."Posted CCD Documents" + Rec."Payroll Documents" + Rec."Posted Payroll Documents" + Rec."LMS Transaction Documents" + Rec."Posted LMS Transc Documents" + Rec."Loyalty Points" + Rec."Posted Loyalty Points" + Rec."LMS Batches" + Rec."Posted LMS Batches" + Rec.Customer;
        exit(CountValue);
    end;

    var
        RecRef: RecordRef;
}