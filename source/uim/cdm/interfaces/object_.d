module uim.cdm.interfaces.object_;

import uim.cdm;

interface ICDMObject {
    // int _id; 
/*   property void Id(int newValue) { }
        /**
        /// Gets or sets the object id.
        */
        int Id();
        void Id(int newId);
        /**
        /// Gets or sets the object context.
        * /
        CdmCorpusContext Ctx { get; set; }
        /**
        /// Gets or sets the declaration document of the object.
        * /
        CdmDocumentDefinition InDocument { get; set; }

        /**
        /// Gets the object declared path.
        */
        string atCorpusPath();

        /**
        /// Gets or sets the object type.
        * /
        CdmObjectType objectType();
        void objectType(CdmObjectType newType);

        /**
        /// Gets or sets the object that owns or contains this object.
        */
        ICDMObject owner();
        void owner(ICDMObject newObject);
        /**
        /// Returns the resolved object reference.
        * /
        T FetchObjectDefinition(T)(ResolveOptions resOpt = null) where T : CdmObjectDefinition;
        
        /**
        Returns the name of the object if this is a defintion or the name of the referenced object if this is an object reference.
        */
        string fetchObjectDefinitionName();
        
        /**
        /// Runs the preChildren and postChildren input functions with this object as input, also calls recursively on any objects this one contains.
        * /
        bool Visit(string pathRoot, VisitCallback preChildren, VisitCallback postChildren);
        /**
        /// Returns true if the object (or the referenced object) is an extension in some way from the specified symbol name.
        * /
        bool IsDerivedFrom(string baseDef, ResolveOptions resOpt = null);
        /**
        /// Validates that the object is configured properly.
        * /
        bool Validate();
        [Obsolete()]
        CdmObjectType GetObjectType();
        [Obsolete()]
        dynamic CopyData(ResolveOptions resOpt = null, CopyOptions options = null);
        /**
        /// Creates a copy of this object.
        * /
        /// <param name="resOpt">The resolve options.</param>
        /// <param name="host"> For CDM private use. Copies the object INTO the provided host instead of creating a new object instance.</param>
        CdmObject Copy(ResolveOptions resOpt, CdmObject host = null);
        /**
        /// Takes an object definition and returns the object reference that points to the definition.
        * /
        /// <param name="resOpt">The resolve options.</param>
        CdmObjectReference CreateSimpleReference(ResolveOptions resOpt = null);
 */    
}