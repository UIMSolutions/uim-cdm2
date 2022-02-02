module uim.cdm.classes.object_definition_base;

import uim.cdm;    

    
abstract class DCDMObjectDefinitionBase : DCDMObjectBase, ICDMObjectDefinition {
    this(ICDMCorpusContext ctx) {  
        super(ctx);
        this._exhibitsTraits = new DCDMTraitCollection(this.ctx, this);
    }
    
    /// Gets or sets the object's explanation.
    mixin(TProperty!("string", "explanation"));

    /**
    Gets the traits this object definition exhibits.
    */
    DCDMTraitCollection _exhibitsTraits;
    DCDMTraitCollection exhibitsTraits() {
        return _exhibitsTraits;
    }
    
    /**
    All object definitions have some kind of name, this method returns the name independent of the name property.
    */
    string _name;
    string name() {
        return _name;
    }

    /*
    private string GetObjectPath() {
        return this.AtCorpusPath;
    }
    /// <inheritdoc />
    abstract override bool IsDerivedFrom(string baseDef, ResolveOptions resOpt = null);
    private void CopyDef(ResolveOptions resOpt, CdmObjectDefinitionBase copy) {
        copy.DeclaredPath = this.DeclaredPath;
        copy.Explanation = this.Explanation;
        copy.ExhibitsTraits.Clear();
        foreach (var trait in this.ExhibitsTraits)
            copy.ExhibitsTraits.Add(trait);
        copy.InDocument = this.InDocument; // if gets put into a new document, this will change. until, use the source
    }
    /// <inheritdoc />
    override string FetchObjectDefinitionName() {
        return this.GetName();
    }
    /// <inheritdoc />
    override T FetchObjectDefinition(T)(ResolveOptions resOpt = null) {
        if (resOpt == null) {
            resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
        }
        return (dynamic)this;
    }
    private bool VisitDef(string pathFrom, VisitCallback preChildren, VisitCallback postChildren) {
        if (this.ExhibitsTraits != null)
            if (this.ExhibitsTraits.VisitList(pathFrom + "/exhibitsTraits/", preChildren, postChildren))
                return true;
        return false;
    }
    private bool IsDerivedFromDef(ResolveOptions resOpt, CdmObjectReference baseCdmObjectRef, string name, string seek) {
        if (seek == name)
            return true;
        CdmObjectDefinition def = baseCdmObjectRef?.FetchObjectDefinition<CdmObjectDefinition>(resOpt);
        if (def != null)
            return def.IsDerivedFrom(seek, resOpt);
        return false;
    }
    private void ConstructResolvedTraitsDef(CdmObjectReference baseCdmObjectRef, ResolvedTraitSetBuilder rtsb, ResolveOptions resOpt) {
        // get from base class first, then see if some are applied to base class on ref then add dynamic traits exhibited by this def
        if (baseCdmObjectRef != null) {
            // merge in all from base class
            rtsb.MergeTraits((baseCdmObjectRef as CdmObjectReferenceBase).FetchResolvedTraits(resOpt));
        }
        // merge in dynamic that are exhibited by this class
        if (this.ExhibitsTraits != null) {
            foreach (CdmTraitReference exhibitsTrait in this.ExhibitsTraits) {
                rtsb.MergeTraits(exhibitsTrait.FetchResolvedTraits(resOpt));
            }
        }
    }
    /// <inheritdoc />
    override CdmObjectReference CreateSimpleReference(ResolveOptions resOpt = null) {
        if (resOpt == null) {
            resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
        }
        string name;
        if (!string.IsNullOrEmpty(this.DeclaredPath))
            name = this.DeclaredPath;
        else
            name = this.GetName();
        CdmObjectReferenceBase cdmObjectRef = this.Ctx.Corpus.MakeObject<CdmObjectReferenceBase>(CdmCorpusDefinition.MapReferenceType(this.ObjectType), name, true) as CdmObjectReferenceBase;
        if (resOpt.SaveResolutionsOnCopy) {
            // used to localize references between documents
            cdmObjectRef.ExplicitReference = this;
            cdmObjectRef.InDocument = this.InDocument;
        }
        return cdmObjectRef;
    }
    /// Creates a 'portable' reference object to this object. portable means there is no symbolic name set until this reference is placed 
    /// into some final document. 
    private override CdmObjectReference CreatePortableReference(ResolveOptions resOpt) {
        CdmObjectReferenceBase cdmObjectRef = this.Ctx.Corpus.MakeObject<CdmObjectReferenceBase>(CdmCorpusDefinition.MapReferenceType(this.ObjectType), "portable", true) as CdmObjectReferenceBase;
        cdmObjectRef.ExplicitReference = this;
        cdmObjectRef.InDocument = this.InDocument; // where it started life
        return cdmObjectRef;
    }
}*/ 
}
