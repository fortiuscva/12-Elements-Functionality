page 52133 "12E Dimension Set Entries"
{
    PageType = API;
    SourceTable = "Dimension Set Entry";
    APIPublisher = 'streamlineinc';
    APIGroup = 'financePBI';
    APIVersion = 'v1.0';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    EntityName = 'dimensionSetEntry';
    EntitySetName = 'dimensionSetEntries';
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; }
                field(dimensionSetId; Rec."Dimension Set ID") { Caption = 'Dimension Set ID'; }   //mapping point
                field(dimensionCode; Rec."Dimension Code") { Caption = 'Dimension Code'; }
                field(dimensionValueID; Rec."Dimension Value ID") { Caption = 'Dimension Value ID'; }   //dimensaion value id
                field(dimensionValueCode; Rec."Dimension Value Code") { Caption = 'Dimension Value Code'; }
                field(dimensionValueName; Rec."Dimension Value Name") { Caption = 'Dimension Value Name'; }
                field(globalDimNo; Rec."Global Dimension No.") { Caption = 'GLobal Dimension No.'; }   //dimension id
            }
        }
    }
}