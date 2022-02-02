module uim.cdm.interfaces.corpus_context;

import uim.cdm;    

interface ICDMCorpusContext {
    @property CdmStatusLevel reportAtLevel();
    @property void reportAtLevel(CdmStatusLevel newLevel);

    @property CdmCorpusDefinition corpus();
    @property void corpus(CdmCorpusDefinition newCorpus);

    @property EventCallback statusEvent();
    @property void statusEvent(EventCallback newCallback);
}
