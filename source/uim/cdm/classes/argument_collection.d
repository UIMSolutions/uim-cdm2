module uim.cdm.classes.argument_collection;

import uim.cdm;    
    
/**
/// <see cref="CdmCollection"/> customized for <see cref="CdmArgumentDefinition"/>.
*/
class DCDMArgumentCollection : DCDMCollection!DCDMArgumentDefinition {
/*         /// <inheritdoc />
        protected new CdmTraitReference Owner
        {
            get
            {
                return base.Owner as CdmTraitReference;
            }
        }
        /**
        /// Constructs a CdmArgumentCollection.
        * /
        /// <param name="ctx">The context.</param>
        /// <param name="owner">The owner of the collection. Has to be a <see cref="CdmTraitReference"/> because this collection is optimized to handle adjustments to the trait when adding an argument.</param>
        CdmArgumentCollection(CdmCorpusContext ctx, CdmTraitReference owner)
            : base(ctx, owner, CdmObjectType.ArgumentDef) {
        }
        /// <inheritdoc />
        new void Insert(int index, CdmArgumentDefinition arg) {
            this.Owner.ResolvedArguments = false;
            base.Insert(index, arg);
        }
        /// <inheritdoc />
        new CdmArgumentDefinition Add(CdmArgumentDefinition arg) {
            this.Owner.ResolvedArguments = false;
            return base.Add(arg);
        }
        /**
        /// Creates an argument based on the name and value provided and adds it to the collection.
        * /
        /// <param name="name">The name of the argument to be created and added to the collection.</param>
        /// <param name="value">The value of the argument to be created and added to the collection.</param>
        /// <returns>The created argument.</returns>
        CdmArgumentDefinition Add(string name, dynamic value) {
            var argument = base.Add(name);
            argument.Value = value;
            this.Owner.ResolvedArguments = false;
            return argument;
        }
        /// <inheritdoc />
        new void AddRange(IEnumerable!CdmArgumentDefinition argumentList) {
            foreach (var argument in argumentList) {
                this.Add(argument);
            }
        }
        /**
        /// Retrieves the value of the argument with the provided name.
        /// If no argument with the provided name is found and there is only one argument with a null name, retrieves the value of this argument.
        * /
        /// <param name="name">The name of the argument we should fetch the value for.</param>
        /// <returns>The value of the argument.</returns>
        dynamic FetchValue(string name) {
            foreach (var argument in this.AllItems) {
                if (string.Equals(argument.Name, name)) {
                    return argument.Value;
                }
            }

            // special case with only one argument and no name give, make a big assumption that this is the one they want
            // right way is to look up parameter def and check name, but this interface is for working on an unresolved def
            if (this.AllItems.Count == 1 && this.AllItems[0].Name == null)
                return this.AllItems[0].Value;
            return null;
        }
        /**
        /// Updates the value of an existing argument. If no argument is found with the provided name, an argument is created and added.
        * /
        /// <param name="name">The name of the argument to be updated.</param>
        /// <param name="value">The value to update the argument with.</param>
        /// <returns>Whether the operation completed successfully.(If an argument with the provided name was found.)</returns>
        void UpdateArgument(string name, dynamic value) {
            this.MakeDocumentDirty();
            foreach (var argument in this.AllItems) {
                if (string.Equals(argument.Name, name)) {
                    argument.Value = value;
                    return;
                }
            }
            this.Add(name, value);
        }
    }
 */
}
