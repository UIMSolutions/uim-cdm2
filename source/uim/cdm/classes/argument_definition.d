module uim.cdm.classes.argument_definition;

import uim.cdm;    

class DCDMArgumentDefinition : DCDMObjectSimple {
        /** 
        Constructs a CdmArgumentDefinition.
        <param name="ctx">The context.</param>
        <param name="name">The argument name.</param>
        */ 
        this(ICDMCorpusContext ctx, string newName) {  
            super(ctx);
            // this.ObjectType = CdmObjectType.ArgumentDef;
            this.name = newName;
        }
        // private CdmParameterDefinition ResolvedParameter { get; set; }
        
        /**
        Gets or sets the argument explanation.
        */
        mixin(TProperty!("string", "explanation"));
        
        /**
        Gets or sets the argument name.
        */
        mixin(TProperty!("string", "name"));
        
        /**
        /// Gets or sets the argument value.
        * /
        dynamic Value { get; set; }
        private dynamic UnResolvedValue { get; set; }
        /**
        [Obsolete]
        override CdmObjectType GetObjectType() {
            return CdmObjectType.ArgumentDef;
        }
        [Obsolete("CopyData is deprecated. Please use the Persistence Layer instead.")]
        override dynamic CopyData(ResolveOptions resOpt, CopyOptions options) {
            return CdmObjectBase.CopyData!CdmArgumentDefinition(this, resOpt, options);
        }
        /// <inheritdoc />
        override CdmObject Copy(ResolveOptions resOpt = null, CdmObject host = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            CdmArgumentDefinition copy;
            if (host == null) {
                copy = new CdmArgumentDefinition(this.Ctx, this.Name);
            }
            else
            {
                copy = host as CdmArgumentDefinition;
                copy.Ctx = this.Ctx;
                copy.Name = this.Name;
            }
            if (this.Value != null) {
                if (this.Value is CdmObject)
                    copy.Value = ((CdmObject)this.Value).Copy(resOpt);
                else
                {
                    // Value is a string or JValue
                    copy.Value = (string)this.Value;
                }
            }
            copy.ResolvedParameter = this.ResolvedParameter;
            copy.Explanation = this.Explanation;
            return copy;
        }
        /// <inheritdoc />
        override bool Validate() {
            if (this.Value == null) {
                Logger.Error(nameof(CdmArgumentDefinition), this.Ctx, Errors.ValidateErrorString(this.AtCorpusPath, new List<string> { "Value" }), nameof(Validate));
                return false;
            }
            return true;
        }
        private CdmParameterDefinition GetParameterDef() {
            return this.ResolvedParameter;
        }
        /// <inheritdoc />
        override bool Visit(string pathFrom, VisitCallback preChildren, VisitCallback postChildren) {
            string path = string.Empty;
            if (this.Ctx.Corpus.blockDeclaredPathChanges == false) {
                path = this.DeclaredPath;
                if (string.IsNullOrEmpty(path)) {
                    path = pathFrom; // name of arg is forced down from trait ref. you get what you get and you don't throw a fit.
                    this.DeclaredPath = path;
                }
            }
            //trackVisits(path);
            if (preChildren != null && preChildren.Invoke(this, path))
                return false;
            if (this.Value != null) {
                Type valueType = this.Value.GetType();
                if (this.Value is CdmObject valueAsJObject) {
                    if (valueAsJObject.Visit($"{path}/value/", preChildren, postChildren))
                        return true;
                }
            }
            if (postChildren != null && postChildren.Invoke(this, path))
                return true;
            return false;
        }
        private string CacheTag() {
            string tag = "";
            dynamic val = this.Value;
            if (val != null) {
                if (this.Value is CdmObject) {
                    tag = (string)val.Id;
                }
                else
                {
                    // val is a string or JValue
                    tag = (string)val;
                }
            }
            return tag;
        }
    }*/
}
