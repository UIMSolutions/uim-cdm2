module uim.cdm.enums.operation_type;

    /**
    /// Enumeration of operation types
    */
    enum ECDMOperationType
    {
        Error,
        AddCountAttribute,
        AddSupportingAttribute,
        AddTypeAttribute,
        ExcludeAttributes,
        ArrayExpansion,
        CombineAttributes,
        RenameAttributes,
        ReplaceAsForeignKey,
        IncludeAttributes,
        AddAttributeGroup
    }
/*     private class OperationTypeConvertor
    {
        private static string OperationTypeToString(CdmOperationType opType) {
            switch (opType) {
                case CdmOperationType.AddCountAttribute:
                    return "addCountAttribute";
                case CdmOperationType.AddSupportingAttribute:
                    return "addSupportingAttribute";
                case CdmOperationType.AddTypeAttribute:
                    return "addTypeAttribute";
                case CdmOperationType.ExcludeAttributes:
                    return "excludeAttributes";
                case CdmOperationType.ArrayExpansion:
                    return "arrayExpansion";
                case CdmOperationType.CombineAttributes:
                    return "combineAttributes";
                case CdmOperationType.RenameAttributes:
                    return "renameAttributes";
                case CdmOperationType.ReplaceAsForeignKey:
                    return "replaceAsForeignKey";
                case CdmOperationType.IncludeAttributes:
                    return "includeAttributes";
                case CdmOperationType.AddAttributeGroup:
                    return "addAttributeGroup";
                case CdmOperationType.Error:
                default:
                    throw new InvalidOperationException();
            }
        }
    }
}
 */