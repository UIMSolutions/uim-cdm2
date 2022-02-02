module uim.cdm.classes.object_simple;

import uim.cdm;    

abstract class DCDMObjectSimple : DCDMObjectBase {
        this(ICDMCorpusContext ctx) {  
            super(ctx);
        }
        /*
        /// <inheritdoc />
        override string FetchObjectDefinitionName() {
            return null;
        }
        /// <inheritdoc />
        override T FetchObjectDefinition(T)(ResolveOptions resOpt = null) 
        {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            return default(T);
        }
        /// <inheritdoc />
        override CdmObjectReference CreateSimpleReference(ResolveOptions resOpt = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            return null;
        }
        private override CdmObjectReference CreatePortableReference(ResolveOptions resOpt) {
            return null;
        }
        /// <inheritdoc />
        override bool IsDerivedFrom(string baseDef, ResolveOptions resOpt = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            return false;
        }
    }
 */
}
