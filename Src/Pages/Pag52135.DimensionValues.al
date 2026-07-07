page 52135 "12E Dimension Values"
{
    PageType = API;
    SourceTable = "Dimension Value";
    APIPublisher = 'streamlineinc';
    APIGroup = 'financePBI';
    APIVersion = 'v1.0';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    EntityName = 'dimensionValue';
    EntitySetName = 'dimensionValues';
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; }
                field(dimensionCode; Rec."Dimension Code") { Caption = 'Dimension Code'; }
                field("code"; Rec.Code) { Caption = 'Code'; }
                field(name; Rec.Name) { Caption = 'Name'; }
                field(dimensionValueType; Rec."Dimension Value Type") { Caption = 'Dimension Value Type'; }
                field(globalDimensionNo; Rec."Global Dimension No.") { Caption = 'Global Dimension No.'; }
                field(dimensionValueID; Rec."Dimension Value ID") { Caption = 'Dimension Value ID'; }   //dimension value id
                field(blocked; Rec.Blocked) { Caption = 'Blocked'; }
                field(totaling; Rec.Totaling) { Caption = 'Totaling'; }
            }
        }
    }
}