module uim.cdm.interfaces.object_definition;

import uim.cdm;    

interface ICDMObjectDefinition : ICDMObject {
    
    /**
    Gets or sets the object's explanation.
    */
    string explanation();
    void explanation(string newExplanation);
    
    /**
    Gets the traits this object definition exhibits.
    */
    DCDMTraitCollection ExhibitsTraits();
    
    /**
    All object definitions have some kind of name, this method returns the name independent of the name property.
    */
    string name();
}
