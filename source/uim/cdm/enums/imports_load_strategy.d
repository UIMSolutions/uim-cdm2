module uim.cdm.enums.imports_load_strategy;

/**
/// Specifies how the OM will load the imports from a document.
*/
enum ECDMImportsLoadStrategy
{
    // With the LazyLoad option, the imports will only be loaded when a symbol from an external file is needed by the OM.
    LazyLoad,
    // The imports will be loaded along with the file.
    Load,
    // The imports will not be loaded at all. If a symbol is needed the OM will log an error.
    DoNotLoad
}

