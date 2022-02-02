module uim.cdm.interfaces.object_reference;

import uim.cdm;    
    
interface ICDMObjectReference : ICDMObject {
    /**
    /// Gets the object reference applied traits.
    */
    DCDMTraitCollection appliedTraits();
    void appliedTraits(DCDMTraitCollection newCollection);
    /**
    Gets or sets the object explicit reference.
    * /
    CdmObjectDefinition ExplicitReference { get; set; }
    
    /**
    Gets or sets the object named reference.
    */
    string namedReference();
    void namedReference(string newReference);

    /**
    Gets or sets whether the reference is simple named or not. If true, use namedReference, else use explicitReference.
    * /
    bool SimpleNamedReference { get; set; }
    [Obsolete("Only for private use.")]
    CdmObject FetchResolvedReference(ResolveOptions resOpt = null);
*/
}
