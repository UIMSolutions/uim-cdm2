﻿module uim.cdm.classes.object_reference_base;

import uim.cdm;    

abstract class DCDMObjectReferenceBase : DCDMObjectBase, ICDMObjectReference {
        this(ICDMCorpusContext ctx, Variant referenceTo, bool simpleReference) {  
            super(ctx);
/*             if (referenceTo != null) {
                if (referenceTo is CdmObject) {
                    this.ExplicitReference = referenceTo as CdmObjectDefinitionBase;
                }
                else
                {
                    // NamedReference is a string or JValue
                    this.NamedReference = referenceTo;
                }
            }
            if (simpleReference)
                this.SimpleNamedReference = true;
            this.AppliedTraits = new CdmTraitCollection(this.Ctx, this);
 */        }

        mixin(TProperty!("string", "namedReference"));

    /*     private static string resAttToken = "/(resolvedAttributes)/";
        /// <inheritdoc />
        CdmObjectDefinition ExplicitReference { get; set; }
        /// <inheritdoc />
        bool SimpleNamedReference { get; set; }
        private CdmDocumentDefinition MonikeredDocument { get; set; }
        /// <inheritdoc />
        CdmTraitCollection AppliedTraits { get; }
        private CdmObjectReferenceBase CopyToHost(CdmCorpusContext ctx, dynamic refTo, bool simpleReference) {
            this.Ctx = ctx;
            this.ExplicitReference = null;
            this.NamedReference = null;
            if (refTo != null) {
                if (refTo is CdmObject) {
                    this.ExplicitReference = refTo as CdmObjectDefinitionBase;
                }
                else
                {
                    // NamedReference is a string or JValue
                    this.NamedReference = refTo;
                }
            }
            this.SimpleNamedReference = simpleReference;
            this.AppliedTraits.Clear();
            return this;
        }
        private static int offsetAttributePromise(string reff) {
            if (string.IsNullOrEmpty(reff))
                return -1;
            return reff.IndexOf(resAttToken);
        }
        [Obsolete("Only for private use.")]
        CdmObject FetchResolvedReference(ResolveOptions resOpt = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            if (this.ExplicitReference != null)
                return this.ExplicitReference;
            if (this.Ctx == null)
                return null;
            ResolveContext ctx = this.Ctx as ResolveContext;
            CdmObjectBase res = null;
            // if this is a special request for a resolved attribute, look that up now
            int seekResAtt = offsetAttributePromise(this.NamedReference);
            if (seekResAtt >= 0) {
                string entName = this.NamedReference.Substring(0, seekResAtt);
                string attName = this.NamedReference.Slice(seekResAtt + resAttToken.Length);
                // get the entity
                CdmObject ent = this.Ctx.Corpus.ResolveSymbolReference(resOpt, this.InDocument, entName, CdmObjectType.EntityDef, retry: true);
                if (ent == null) {
                    Logger.Warning(nameof(CdmObjectReferenceBase), ctx, $"unable to resolve an entity named '{entName}' from the reference '{this.NamedReference}");
                    return null;
                }
                // get the resolved attribute
                ResolvedAttributeSet ras = (ent as CdmObjectDefinitionBase).FetchResolvedAttributes(resOpt);
                ResolvedAttribute ra = null;
                if (ras != null)
                    ra = ras.Get(attName);
                if (ra != null)
                    res = ra.Target as dynamic;
                else
                {
                    Logger.Warning(nameof(CdmObjectReferenceBase), ctx, $"couldn't resolve the attribute promise for '{this.NamedReference}'", $"{resOpt.WrtDoc.AtCorpusPath}");
                }
            }
            else
            {
                // normal symbolic reference, look up from the Corpus, it knows where everything is
                res = this.Ctx.Corpus.ResolveSymbolReference(resOpt, this.InDocument, this.NamedReference, this.ObjectType, retry: true);
            }
            return res;
        }
        /// <inheritdoc />
        override CdmObjectReference CreateSimpleReference(ResolveOptions resOpt = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            if (!string.IsNullOrEmpty(this.NamedReference))
                return this.CopyRefObject(resOpt, this.NamedReference, true);
            string newDeclaredPath = this.DeclaredPath?.EndsWith("/(ref)") == true ? this.DeclaredPath.Substring(0, this.DeclaredPath.Length - 6) : this.DeclaredPath;
            return this.CopyRefObject(resOpt, newDeclaredPath, true);
        }
        /// Creates a 'portable' reference object to this object. portable means there is no symbolic name set until this reference is placed 
        /// into some final document. 
        private override CdmObjectReference CreatePortableReference(ResolveOptions resOpt) {
            CdmObjectReferenceBase cdmObjectRef = this.Ctx.Corpus.MakeObject<CdmObjectReferenceBase>(CdmCorpusDefinition.MapReferenceType(this.ObjectType), "portable", true) as CdmObjectReferenceBase;
            cdmObjectRef.ExplicitReference = this.FetchObjectDefinition<CdmObjectDefinition>(resOpt);
            if (cdmObjectRef.ExplicitReference == null || (cdmObjectRef.InDocument == null && this.InDocument == null))
                return null; // not allowed
            if (cdmObjectRef.InDocument == null) {
                cdmObjectRef.InDocument = this.InDocument; // if the object has no document, take from the reference
            }
            return cdmObjectRef;
        }
        /// Creates a 'portable' reference object to this object. portable means there is no symbolic name set until this reference is placed 
        /// into some final document. 
        private void LocalizePortableReference(ResolveOptions resOpt, string importPath) {
            string newDeclaredPath = (this.ExplicitReference as CdmObjectBase).DeclaredPath;
            newDeclaredPath =  newDeclaredPath?.EndsWith("/(ref)") == true ? newDeclaredPath.Substring(0, newDeclaredPath.Length - 6) : newDeclaredPath;
            this.NamedReference = $"{importPath}{newDeclaredPath}";
        }
        /// <inheritdoc />
        override CdmObject Copy(ResolveOptions resOpt = null, CdmObject host = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            dynamic copy;
            if (!string.IsNullOrEmpty(this.NamedReference)) {
                copy = this.CopyRefObject(resOpt, this.NamedReference, this.SimpleNamedReference, host as CdmObjectReferenceBase);
            }
            else
            {
                copy = this.CopyRefObject(resOpt, this.ExplicitReference, this.SimpleNamedReference, host as CdmObjectReferenceBase);
            }
            if (resOpt.SaveResolutionsOnCopy) {
                copy.ExplicitReference = this.ExplicitReference;
            }
            copy.AppliedTraits.Clear();
            if (this.AppliedTraits != null) {
                foreach (var trait in this.AppliedTraits)
                    copy.AppliedTraits.Add(trait);
            }
            // Don't do anything else after this, as it may cause InDocument to become dirty
            copy.InDocument = this.InDocument;
            return copy;
        }
        private abstract CdmObjectReferenceBase CopyRefObject(ResolveOptions resOpt, dynamic refTo, bool simpleReference, CdmObjectReferenceBase host = null);
        /// <inheritdoc />
        override string FetchObjectDefinitionName() {
            if (!string.IsNullOrEmpty(this.NamedReference)) {
                int pathEnd = this.NamedReference.LastIndexOf('/');
                if (pathEnd == -1 || pathEnd + 1 == this.NamedReference.Length) {
                    return this.NamedReference;
                }
                else
                {
                    return this.NamedReference.Substring(pathEnd + 1);
                }
            }
            if (this.ExplicitReference != null)
                return this.ExplicitReference.GetName();
            return null;
        }
        /// <inheritdoc />
        override bool IsDerivedFrom(string baseDef, ResolveOptions resOpt = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            var def = this.FetchObjectDefinition<CdmObjectDefinitionBase>(resOpt);
            if (def != null) {
                return def.IsDerivedFrom(baseDef, resOpt);
            }
            return false;
        }
        /// <inheritdoc />
        override T FetchObjectDefinition(T)(ResolveOptions resOpt = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            dynamic def = this.FetchResolvedReference(resOpt) as dynamic;
            if (def != null) {
                if (def is CdmObjectReferenceBase) {
                    def = def.FetchResolvedReference(resOpt) as dynamic;
                }
            }
            if (def != null && !(def is CdmObjectReference))
                return def;
            return default(T);
        }
        /// <inheritdoc />
        override bool Validate() {
            List<string> missingFields = new List<string>() { "NamedReference", "ExplicitReference" };
            if (string.IsNullOrWhiteSpace(this.NamedReference) && this.ExplicitReference == null) {
                Logger.Error(nameof(CdmObjectReferenceBase), this.Ctx, Errors.ValidateErrorString(this.AtCorpusPath, missingFields, true), nameof(Validate));
                return false;
            }
            return true;
        }
        /// <inheritdoc />
        override bool Visit(string pathFrom, VisitCallback preChildren, VisitCallback postChildren) {
            string path = string.Empty;
            if (this.Ctx.Corpus.blockDeclaredPathChanges == false) {
                path = this.DeclaredPath;
                if (!string.IsNullOrEmpty(this.NamedReference))
                    path = pathFrom + this.NamedReference;
                else
                {
                    // when an object is defined inline inside a reference, we need a path to the reference
                    // AND a path to the inline object. The 'correct' way to do this is to name the reference (inline) and the
                    // defined object objectName so you get a path like extendsEntity/(inline)/MyBaseEntity. that way extendsEntity/(inline)
                    // gets you the reference where there might be traits, etc. and extendsEntity/(inline)/MyBaseEntity gets the
                    // entity defintion. HOWEVER! there are situations where (inline) would be ambiguous since there can be more than one
                    // object at the same level, like anywhere there is a collection of references or the collection of attributes.
                    // so we will flip it (also preserves back compat) and make the reference extendsEntity/MyBaseEntity/(inline) so that
                    // extendsEntity/MyBaseEntity gives the reference (like before) and then extendsEntity/MyBaseEntity/(inline) would give
                    // the inline defined object.
                    // ALSO, ALSO!!! since the ability to use a path to request an object (through) a reference is super useful, lets extend
                    // the notion and use the word (object) in the path to mean 'drill from reference to def' This would work then on
                    // ANY reference, not just inline ones
                    if (this.ExplicitReference != null) {
                        // ref path is name of defined object
                        path = $"{pathFrom}{this.ExplicitReference.GetName()}";
                        // inline object path is a request for the defintion. setting the declaredPath
                        // keeps the visit on the explcitReference from using the defined object name
                        // as the path to that object
                        (this.ExplicitReference as CdmObjectDefinitionBase).DeclaredPath = path;
                    }
                    else
                    {
                        path = pathFrom;
                    }
                }
                this.DeclaredPath = $"{path}/(ref)";
            }
            string refPath = this.DeclaredPath;
            if (preChildren != null && preChildren.Invoke(this, refPath))
                return false;
            if (this.ExplicitReference != null && string.IsNullOrEmpty(this.NamedReference)) {
                this.ExplicitReference.Owner = this.Owner; // obj is not in collection, so set owner here.
                if (this.ExplicitReference.Visit(path, preChildren, postChildren))
                    return true;
            }
            if (this.VisitRef(path, preChildren, postChildren))
                return true;
            if (this.AppliedTraits != null)
                if (this.AppliedTraits.VisitList(refPath + "/appliedTraits/", preChildren, postChildren))
                    return true;
            if (postChildren != null && postChildren.Invoke(this, refPath))
                return true;
            return false;
        }
        private abstract bool VisitRef(string pathFrom, VisitCallback preChildren, VisitCallback postChildren);
        private override ResolvedAttributeSetBuilder ConstructResolvedAttributes(ResolveOptions resOpt, CdmAttributeContext under = null) {
            // find and cache the complete set of attributes
            ResolvedAttributeSetBuilder rasb = new ResolvedAttributeSetBuilder();
            rasb.ResolvedAttributeSet.AttributeContext = under;
            var def = this.FetchObjectDefinition<CdmObjectDefinitionBase>(resOpt);
            if (def != null) {
                AttributeContextParameters acpRef = null;
                if (under != null) {
                    // ask for a 'pass through' context, that is, no new context at this level
                    acpRef = new AttributeContextParameters() {
                        under = under,
                        type = CdmAttributeContextType.PassThrough
                    };
                }
                ResolvedAttributeSet resAtts = def.FetchResolvedAttributes(resOpt, acpRef);
                if (resAtts?.Set?.Count > 0) {
                    //resAtts = resAtts.Copy(); should not neeed this copy now that we copy from the cache. lets try!
                    rasb.MergeAttributes(resAtts);
                    rasb.RemoveRequestedAtts();
                }
            }
            else
            {
                string defName = this.FetchObjectDefinitionName();
                Logger.Warning(defName, this.Ctx, $"unable to resolve an object from the reference '{defName}'");
            }
            return rasb;
        }
        private override ResolvedTraitSet FetchResolvedTraits(ResolveOptions resOpt = null) {
            bool wasPreviouslyResolving = this.Ctx.Corpus.isCurrentlyResolving;
            this.Ctx.Corpus.isCurrentlyResolving = true;
            var ret = this._fetchResolvedTraits(resOpt);
            this.Ctx.Corpus.isCurrentlyResolving = wasPreviouslyResolving;
            return ret;
        }
        private ResolvedTraitSet _fetchResolvedTraits(ResolveOptions resOpt = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            if (this.NamedReference != null && this.AppliedTraits == null) {
                const string kind = "rts";
                ResolveContext ctx = this.Ctx as ResolveContext;
                var objDef = this.FetchObjectDefinition<CdmObjectDefinitionBase>(resOpt);
                string cacheTag = ctx.Corpus.CreateDefinitionCacheTag(resOpt, this, kind, "", true, objDef != null ? objDef.AtCorpusPath : null);
                dynamic rtsResultDynamic = null;
                if (cacheTag != null)
                    ctx.Cache.TryGetValue(cacheTag, out rtsResultDynamic);
                ResolvedTraitSet rtsResult = rtsResultDynamic as ResolvedTraitSet;
                // store the previous document set, we will need to add it with
                // children found from the constructResolvedTraits call
                SymbolSet currSymRefSet = resOpt.SymbolRefSet;
                if (currSymRefSet == null)
                    currSymRefSet = new SymbolSet();
                resOpt.SymbolRefSet = new SymbolSet();
                if (rtsResult == null) {
                    if (objDef != null) {
                        rtsResult = (objDef as CdmObjectDefinitionBase).FetchResolvedTraits(resOpt);
                        if (rtsResult != null)
                            rtsResult = rtsResult.DeepCopy();
                        // register set of possible docs
                        ctx.Corpus.RegisterDefinitionReferenceSymbols(objDef, kind, resOpt.SymbolRefSet);
                        // get the new cache tag now that we have the list of docs
                        cacheTag = ctx.Corpus.CreateDefinitionCacheTag(resOpt, this, kind, "", true, objDef.AtCorpusPath);
                        if (!string.IsNullOrWhiteSpace(cacheTag))
                            ctx.Cache[cacheTag] = rtsResult;
                    }
                }
                else
                {
                    // cache was found
                    // get the SymbolSet for this cached object
                    string key = CdmCorpusDefinition.CreateCacheKeyFromObject(this, kind);
                    ctx.Corpus.DefinitionReferenceSymbols.TryGetValue(key, out SymbolSet tempDocRefSet);
                    resOpt.SymbolRefSet = tempDocRefSet;
                }
                // merge child document set with current
                currSymRefSet.Merge(resOpt.SymbolRefSet);
                resOpt.SymbolRefSet = currSymRefSet;
                return rtsResult;
            }
            else
                return base.FetchResolvedTraits(resOpt);
        }
        private override void ConstructResolvedTraits(ResolvedTraitSetBuilder rtsb, ResolveOptions resOpt) {
            CdmObjectDefinition objDef = this.FetchObjectDefinition<CdmObjectDefinition>(resOpt);
            if (objDef != null) {
                ResolvedTraitSet rtsInh = (objDef as CdmObjectDefinitionBase).FetchResolvedTraits(resOpt);
                if (rtsInh != null) {
                    rtsInh = rtsInh.DeepCopy();
                }
                rtsb.TakeReference(rtsInh);
            }
            else
            {
                string defName = this.FetchObjectDefinitionName();
                Logger.Warning(defName, this.Ctx, $"unable to resolve an object from the reference '{defName}'");
            }
            if (this.AppliedTraits != null) {
                foreach (CdmTraitReference at in this.AppliedTraits) {
                    rtsb.MergeTraits(at.FetchResolvedTraits(resOpt));
                }
            }
        }
    }
 */}
