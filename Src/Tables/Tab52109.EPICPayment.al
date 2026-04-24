table 52109 "12E EPIC Payment"
{
    Caption = 'EPIC Payment';
    DataClassification = CustomerContent;
    LookupPageId = "12E EPIC Payments";
    DrillDownPageId = "12E EPIC Payments";
    DataPerCompany = false;

    fields
    {
        field(1; "Data Source ID"; Integer)
        {
            Caption = 'Data Source ID';
            TableRelation = "12E EPIC DataSourceID Map";
            ValidateTableRelation = false;
        }
        field(2; "Payments ID"; Integer)
        {
            Caption = 'Payments ID';
        }
        field(5; "Effective Date"; DateTime)
        {
            Caption = 'Effective Date';
        }
        field(10; "Payment Type"; Code[20])
        {
            Caption = 'Payment Type';
            TableRelation = "12E EPIC Payment Type";
            ValidateTableRelation = false;
        }
        field(15; Principal; Decimal)
        {
            Caption = 'Principal';
            DecimalPlaces = 0 : 5;
        }
        field(20; "Late Fee"; Decimal)
        {
            Caption = 'Late Fee';
            DecimalPlaces = 0 : 5;
        }
        field(25; "NSF Fee"; Decimal)
        {
            Caption = 'NSF Fee';
            DecimalPlaces = 0 : 5;
        }
        field(30; "Return Code"; Code[10])
        {
            Caption = 'Return Code';
        }
        field(35; "Return Date"; DateTime)
        {
            Caption = 'Return Date';
        }
        field(40; "Payment Status"; enum "12E EPIC Payment Status")
        {
            Caption = 'Payment Status';
        }
        field(45; IsDebit; Boolean)
        {
            Caption = 'IsDebit';
        }
        field(50; "Success Date"; DateTime)
        {
            Caption = 'Success Date';
        }
        field(55; "Is Origination"; Boolean)
        {
            Caption = 'Is Origination';
        }
        field(60; "Credit Reason"; Text[50])
        {
            Caption = 'Credit Reason';
        }
        field(65; "Loan ID"; Integer)
        {
            Caption = 'Loan ID';
        }
        field(70; "Finance Fee"; Decimal)
        {
            Caption = 'Finance Fee';
            DecimalPlaces = 0 : 5;
        }
        field(75; "Fees Amount"; Decimal)
        {
            Caption = 'Fees Amount';
            DecimalPlaces = 0 : 5;
        }
        field(80; "Payment Amount"; Decimal)
        {
            Caption = 'Payment Amount';
            DecimalPlaces = 0 : 5;
        }
        field(85; "ACH Endpoint"; Code[20])
        {
            Caption = 'ACH Endpoint';
            TableRelation = "12E EPIC Bank Account".Endpoint;
            ValidateTableRelation = false;
        }
        field(90; "Assigned Agent"; Text[20])
        {
            Caption = 'Assigned Agent';
        }
        field(95; "Payment Agent"; Text[20])
        {
            Caption = 'Payment Agent';
        }
        field(100; "Authorization Type"; enum "12E EPIC Payment Auth. Type")
        {
            Caption = 'Authorization Type';

        }
        field(105; "Service Fee"; Decimal)
        {
            Caption = 'Service Fee';
            DecimalPlaces = 0 : 5;
        }
        field(110; "Service Fee Interest"; Decimal)
        {
            Caption = 'Service Fee Interest';
            DecimalPlaces = 0 : 5;
        }
        field(115; "Origination Fee"; Decimal)
        {
            Caption = 'Origination Fee';
            DecimalPlaces = 0 : 5;
        }
        field(120; "Management Fee"; Decimal)
        {
            Caption = 'Management Fee';
            DecimalPlaces = 0 : 5;
        }
        field(125; "Maintenance Fee"; Decimal)
        {
            Caption = 'Maintenance Fee';
            DecimalPlaces = 0 : 5;
        }
        field(130; "Is Makeup"; Boolean)
        {
            Caption = 'Is Makeup';
        }
        field(135; "Is Additional Payment"; Boolean)
        {
            Caption = 'Is Additional Payment';
        }
        field(140; "Is Payoff Payment"; Boolean)
        {
            Caption = 'Is Payoff Payment';
        }
        field(141; "Debit Card Endpoint Name"; Text[30])
        {
            Caption = 'Debit Card Endpoint Name';
        }
        field(142; "RTT Return Code"; Code[20])
        {
            Caption = 'RTT Return Code';
        }
        field(145; County; Text[30])
        {
            Caption = 'County';
            OptimizeForTextSearch = true;
            ToolTip = 'Specifies the state, province or county as a part of the address.';
            DataClassification = CustomerContent;
        }
        field(148; "Store Code"; Code[20])
        {
            Caption = 'Store';
            DataClassification = CustomerContent;
        }
        field(150; "Loan Status"; enum "12E EPIC Posting Loan Status")
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(154; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Data Source ID", "Payments ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Dropdown; "Data Source ID", "Payments ID")
        {

        }
    }
}
