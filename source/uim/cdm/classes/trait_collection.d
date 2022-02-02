module uim.cdm.classes.trait_collection;

import uim.cdm;    

/**
/// <see cref="CdmCollection"/> customized for <see cref="CdmTraitReference"/>.
*/
class DCDMTraitCollection : DCDMCollection!DCDMTraitReference {
        /// Constructs a CdmTraitCollection by using the parent constructor and TraitRef as the default type.
        /// <param name="ctx">The context.</param>
        /// <param name="owner">The object this collection is a member of.</param>
        this(ICDMCorpusContext ctx, ICDMObject owner) {
            // super(ctx, owner, CdmObjectType.TraitRef);
        }
        /*
        /// <inheritdoc />
        new void Insert(int index, CdmTraitReference trait) {
            this.ClearCache();
            base.Insert(index, trait);
        }
        /**
        /// Creates a <see cref="CdmTraitReference"/> based on a <see cref="CdmTraitDefinition"/> and adds it to the collection.
        * /
        /// <param name="traitDefinition">The trait definition used to create the trait reference.</param>
        /// <param name="simpleRef">Used to set trait.SimpleNamedReference in the constructor.</param>
        /// <returns>The created trait reference that was added to the collection.</returns>
        CdmTraitReference Add(CdmTraitDefinition traitDefinition, bool simpleRef = false) {
            this.ClearCache();
            var traitReference = new CdmTraitReference(this.Ctx, traitDefinition, simpleRef, false);
            return base.Add(traitReference);
        }
        /**
        /// Adds a <see cref="CdmTraitReference"/> to this collection.
        * /
        /// <param name="trait">The trait to be added.</param>
        /// <returns>The created trait reference that was added to the collection.</returns>
        new CdmTraitReference Add(CdmTraitReference trait) {
            this.ClearCache();
            return base.Add(trait);
        }
        
        /// < inheritdoc/>
        new CdmTraitReference Add(string name, bool simpleRef = false) {
            this.ClearCache();
            return base.Add(name, simpleRef);
        }

        /**
        /// Removes the <see cref="CdmTraitReference"/> that has the same name as <see cref="CdmTraitDefinition"/>.
        /// If there are multiple matches, removes the first trait that is from a property. If there aren't any from properties and "onlyFromProperty" is false, removes the last trait that is not from a property.        
        * /
        /// <param name="traitDefToRemove"><see cref="CdmTraitDefinition"/> whose reference to remove from the collection.</param>
        /// <param name="onlyFromProperty">Whether the function should only be applied for traits that originate from properties.</param>
        /// <returns>Whether the operation completed successfuly.</returns>
        bool Remove(CdmTraitDefinition traitDefToRemove, bool onlyFromProperty = false) {
            var traitName = traitDefToRemove.TraitName;
            return this.Remove(traitName, onlyFromProperty);
        }
        /**
        /// Removes the trait with the specified name from the collection.
        /// If there are multiple matches, removes the first trait that is from a property. If there aren't any from properties and "onlyFromProperty" is false, removes the last trait that is not from a property.
        * /
        /// <param name="traitName">The name of the trait to be removed.</param>
        /// <param name="onlyFromProperty">Whether the function should only be applied for traits that originate from properties.</param>
        /// <returns>Whether a trait was removed from the collection.</returns>
        bool Remove(string traitName, bool onlyFromProperty = false) {
            this.MakeDocumentDirty();
            CdmTraitReference foundTraitNotFromProperty = null;
            this.ClearCache();
            foreach (CdmTraitReference trait in this.AllItems) {
                if (this.Corresponds(trait, traitName)) {
                    if (trait.IsFromProperty) {
                        PropagateInDocument(trait, null);
                        return this.AllItems.Remove(trait);
                    }
                    foundTraitNotFromProperty = trait;
                }
            }
            if (onlyFromProperty == false && foundTraitNotFromProperty != null) {
                PropagateInDocument(foundTraitNotFromProperty, null);
                return this.AllItems.Remove(foundTraitNotFromProperty);
            }
            return false;
        }
        /**
        /// Removes a trait with the same name as the trait provided.
        /// If there are multiple matches, removes the first trait that is from a property. If there aren't any from properties and "onlyFromProperty" is false, removes the last trait that is not from a property.
        * /
        /// <param name="traitToRemove">The trait to be removed.</param>
        /// <param name="onlyFromProperty">Whether the function should only be applied for traits that originate from properties.</param>
        /// <returns>Whether a trait was removed from the collection.</returns>
        bool Remove(CdmTraitReference traitToRemove, bool onlyFromProperty = false) {
            var traitName = traitToRemove.FetchObjectDefinitionName();
            return Remove(traitName, onlyFromProperty);
        }
        /// <inheritdoc />
        new void RemoveAt(int index) {
            this.ClearCache();
            base.RemoveAt(index);
        }
        /// <inheritdoc />
        new void Clear() {
            this.ClearCache();
            base.Clear();
        }
        /**
        /// Retrieves the index of a trait reference with the same name as the trait definition provided.
        /// If there are multiple matches, returns the index of the first trait that is from a property. If there aren't any from properties and "onlyFromProperty" is false, returns the index of the last trait that is not from a property.
        * /
        /// <param name="traitDefinition">The trait definition associated with the trait reference we want to retrieve the index of.</param>
        /// <param name="onlyFromProperty">Whether the function should only be applied for traits that originate from properties.</param>
        /// <returns>The index of the trait reference or -1 if no such trait exists in the collection.</returns>
        int IndexOf(CdmTraitDefinition traitDefinition, bool onlyFromProperty = false) {
            var traitName = traitDefinition.TraitName;
            return IndexOf(traitName, onlyFromProperty);
        }
        /**
        /// Retrieves the index of a trait reference with the given name.
        /// If there are multiple matches, returns the index of the first trait that is from a property. If there aren't any from properties and "onlyFromProperty" is false, returns the index of the last trait that is not from a property.
        * /
        /// <param name="traitName">The trait name associated with the trait reference we want to retrieve the index of.</param>
        /// <param name="onlyFromProperty">Whether the function should only be applied for traits that originate from properties.</param>
        /// <returns>The index of the trait reference or -1 if no such trait exists in the collection.</returns>
        int IndexOf(string traitName, bool onlyFromProperty = false) {
            int indexOfTraitNotFromProperty = -1;
            for (int index = 0; index < this.AllItems.Count; index++) {
                if (this.Corresponds(this.AllItems[index], traitName)) {
                    if (this.AllItems[index].IsFromProperty) {
                        return index;
                    }
                    indexOfTraitNotFromProperty = index;
                }
            }
            if (onlyFromProperty == false) {
                return indexOfTraitNotFromProperty;
            }
            return -1;
        }
        /**
        /// Retrieves the index of a trait with the same name as the trait provided.
        /// If there are multiple matches, returns the index of the first trait that is from a property. If there aren't any from properties and "onlyFromProperty" is false, returns the index of the last trait that is not from a property.
        * /
        /// <param name="trait">The trait we want the index of.</param>
        /// <param name="onlyFromProperty">Whether the function should only be applied for traits that originate from properties.</param>
        /// <returns>The index of the trait reference or -1 if no such trait exists in the collection.</returns>
        int IndexOf(CdmTraitReference trait, bool onlyFromProperty) {
            var traitName = trait.FetchObjectDefinitionName();
            return IndexOf(traitName, onlyFromProperty);
        }
        /**
        /// Adds the elements of a list of <see cref="CdmTraitDefinition"/> to the collection, after converting them to <see cref="CdmTraitReference"/>.
        * /
        /// <param name="traitList">The list of trait definitions used to create trait references that will be added to the collection.</param>
        /// <param name="simpleRef">Parameter is unused for this collection. Kept for consistency with other CdmCollections.</param>
        void AddRange(IEnumerable<CdmTraitDefinition> traitList, bool simpleRef = false) {
            foreach (var element in traitList) {
                this.Add(element);
            }
        }
        /**
        /// Checks whether a <see cref="CdmTraitReference"/> has a particular name.
        * /
        /// <param name="traitReference">The trait reference.</param>
        /// <param name="traitDefinition">The trait name.</param>
        /// <returns>Whether the trait reference has the given name.</returns>
        private bool Corresponds(CdmTraitReference traitReference, string traitName) {
            return string.Equals(traitReference.FetchObjectDefinitionName(), traitName);
        }
        /**
        /// Clears the trait cache of the owner if the owner object contains such a cache.
        * /
        private void ClearCache() {
            if (this.Owner is CdmObjectBase owner) {
                owner.ClearTraitCache();
            }
        }
    }*/
}
