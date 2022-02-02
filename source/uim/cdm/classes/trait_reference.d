﻿module uim.cdm.classes.trait_reference;

import uim.cdm;    
    
class DCDMTraitReference : DCDMObjectReferenceBase {
        /// Constructs a CdmTraitReference.
        /// <param name="ctx">The context.</param>
        /// <param name="trait">The trait to referemce.</param>
        /// <param name="simpleReference">Whether this reference is a simple reference.</param>
        /// <param name="hasArguments">Whether this reference has arguments.</param>
        this(ICDMCorpusContext ctx, Variant trait, bool simpleReference, bool hasArguments) {
            super(ctx, trait, simpleReference);

/*             this.ObjectType = CdmObjectType.TraitRef;
            this.ResolvedArguments = false;
            this.IsFromProperty = false;
            this.Arguments = new CdmArgumentCollection(this.Ctx, this);
 */        }

        /// Gets or sets whether the trait was generated (true) from a property or if it was directly loaded (false).
        mixin(TProperty!("bool", "isFromProperty"));

        /**
        /// Gets the trait reference's arguments.
        * /
        CdmArgumentCollection Arguments { get; }
        private bool ResolvedArguments;
        private override CdmObjectReferenceBase CopyRefObject(ResolveOptions resOpt, dynamic refTo, bool simpleReference, CdmObjectReferenceBase host = null) {
            CdmTraitReference copy;
            if (host == null)
                copy = new CdmTraitReference(this.Ctx, refTo, simpleReference, this.Arguments?.Count > 0);
            else
            {
                copy = host.CopyToHost(this.Ctx, refTo, simpleReference);
                copy.Arguments.Clear();
            }
            if (!simpleReference) {
                copy.ResolvedArguments = this.ResolvedArguments;
            }
            foreach (var arg in this.Arguments)
                copy.Arguments.Add(arg);
            return copy;
        }
        [Obsolete("CopyData is deprecated. Please use the Persistence Layer instead.")]
        override dynamic CopyData(ResolveOptions resOpt, CopyOptions options) {
            return CdmObjectBase.CopyData<CdmTraitReference>(this, resOpt, options);
        }
        /// Returns a map from parameter names to the final argument values for a trait reference.
        /// Values come (in this order) from base trait defaults, then default overrides on inheritence,
        /// then values supplied on this reference.
        Dictionary<string, dynamic> FetchFinalArgumentValues(ResolveOptions resOpt) {
            Dictionary<string, dynamic> finalArgs = new Dictionary<string, dynamic>();
            // get resolved traits does all the work, just clean up the answers
            ResolvedTraitSet rts = this.FetchResolvedTraits(resOpt);
            if (rts == null || rts.Size != 1) {
                // well didn't get the traits. maybe imports are missing or maybe things are just not defined yet.
                // this function will try to fake up some answers then from the arguments that are set on this reference only
                if (this.Arguments != null && this.Arguments.Count > 0) {
                    int unNamedCount = 0;
                    foreach(var arg in this.Arguments) {
                        // if no arg name given, use the position in the list.
                        string argName = arg.Name;
                        if (string.IsNullOrWhiteSpace(argName)) {
                            argName = unNamedCount.ToString();
                        }
                        finalArgs.Add(argName, arg.Value);
                        unNamedCount++;
                    }
                    return finalArgs;
                }
                return null;
            }
            // there is only one resolved trait
            ResolvedTrait rt = rts.First;
            if (rt?.ParameterValues != null && rt.ParameterValues.Length > 0) {
                int l = rt.ParameterValues.Length;
                for (int i = 0; i < l; i++) {
                    var p = rt.ParameterValues.FetchParameterAtIndex(i);
                    dynamic v = rt.ParameterValues.FetchValue(i);
                    string name = p.Name;
                    if (name == null) {
                        name = i.ToString();
                    }
                    finalArgs.Add(name, v);
                }
            }
            return finalArgs;
        }
        [Obsolete]
        override CdmObjectType GetObjectType() {
            return CdmObjectType.TraitRef;
        }
        private override bool VisitRef(string pathFrom, VisitCallback preChildren, VisitCallback postChildren) {
            bool result = false;
            if (this.Arguments?.Count > 0) {
                // custom enumeration of args to force a path onto these things that just might not have a name
                int lItem = this.Arguments.Count;
                for (int iItem = 0; iItem < lItem; iItem++) {
                    CdmArgumentDefinition element = this.Arguments[iItem];
                    if (element != null) {
                        string argPath = $"{pathFrom}/arguments/a{iItem}";
                        if (element.Visit(argPath, preChildren, postChildren)) {
                            result = true;
                            break;
                        }
                    }
                }
            }
            return result;
        }
        private override ResolvedAttributeSetBuilder ConstructResolvedAttributes(ResolveOptions resOpt, CdmAttributeContext under = null) {
            return null;
        }
        private override ResolvedTraitSet FetchResolvedTraits(ResolveOptions resOpt = null) {
            if (resOpt == null) {
                resOpt = new ResolveOptions(this, this.Ctx.Corpus.DefaultResolutionDirectives);
            }
            const string kind = "rtsb";
            var ctx = this.Ctx as ResolveContext;
            // get referenced trait
            var trait = this.FetchObjectDefinition<CdmTraitDefinition>(resOpt);
            ResolvedTraitSet rtsTrait = null;
            if (trait == null)
                return ctx.Corpus.CreateEmptyResolvedTraitSet(resOpt);
            // see if one is already cached
            // cache by name unless there are parameter
            if (trait.ThisIsKnownToHaveParameters == null) {
                // never been resolved, it will happen soon, so why not now?
                rtsTrait = trait.FetchResolvedTraits(resOpt);
            }
            bool cacheByPath = true;
            if (trait.ThisIsKnownToHaveParameters != null) {
                cacheByPath = !((bool)trait.ThisIsKnownToHaveParameters);
            }
            string cacheTag = ctx.Corpus.CreateDefinitionCacheTag(resOpt, this, kind, "", cacheByPath, trait.AtCorpusPath);
            dynamic rtsResult = null;
            if (cacheTag != null)
                ctx.Cache.TryGetValue(cacheTag, out rtsResult);
            // store the previous reference symbol set, we will need to add it with
            // children found from the constructResolvedTraits call
            SymbolSet currSymRefSet = resOpt.SymbolRefSet;
            if (currSymRefSet == null)
                currSymRefSet = new SymbolSet();
            resOpt.SymbolRefSet = new SymbolSet();
            // if not, then make one and save it
            if (rtsResult == null) {
                // get the set of resolutions, should just be this one trait
                if (rtsTrait == null) {
                    // store current symbol ref set
                    SymbolSet newSymbolRefSet = resOpt.SymbolRefSet;
                    resOpt.SymbolRefSet = new SymbolSet();
                    rtsTrait = trait.FetchResolvedTraits(resOpt);
                    // bubble up symbol reference set from children
                    if (newSymbolRefSet != null) {
                        newSymbolRefSet.Merge(resOpt.SymbolRefSet);
                    }
                    resOpt.SymbolRefSet = newSymbolRefSet;
                }
                if (rtsTrait != null)
                    rtsResult = rtsTrait.DeepCopy();
                // now if there are argument for this application, set the values in the array
                if (this.Arguments != null && rtsResult != null) {
                    // if never tried to line up arguments with parameters, do that
                    if (!this.ResolvedArguments) {
                        this.ResolvedArguments = true;
                        ParameterCollection param = trait.FetchAllParameters(resOpt);
                        CdmParameterDefinition paramFound = null;
                        dynamic aValue = null;
                        int iArg = 0;
                        if (this.Arguments != null) {
                            foreach (CdmArgumentDefinition argument in this.Arguments) {
                                paramFound = param.ResolveParameter(iArg, argument.Name);
                                argument.ResolvedParameter = paramFound;
                                aValue = argument.Value;
                                aValue = ctx.Corpus.ConstTypeCheck(resOpt, this.InDocument, paramFound, aValue);
                                argument.Value = aValue;
                                iArg++;
                            }
                        }
                    }
                    if (this.Arguments != null) {
                        foreach (CdmArgumentDefinition a in this.Arguments) {
                            rtsResult.SetParameterValueFromArgument(trait, a);
                        }
                    }
                }
                // register set of possible symbols
                ctx.Corpus.RegisterDefinitionReferenceSymbols(this.FetchObjectDefinition<CdmObjectDefinition>(resOpt), kind, resOpt.SymbolRefSet);
                // get the new cache tag now that we have the list of symbols
                cacheTag = ctx.Corpus.CreateDefinitionCacheTag(resOpt, this, kind, "", cacheByPath, trait.AtCorpusPath);
                if (!string.IsNullOrWhiteSpace(cacheTag))
                    ctx.Cache[cacheTag] = rtsResult;
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
        private override void ConstructResolvedTraits(ResolvedTraitSetBuilder rtsb, ResolveOptions resOpt) {
            return;
        }
    } */
}
