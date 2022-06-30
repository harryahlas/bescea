# part I from https://towardsdatascience.com/how-to-build-a-search-engine-9f8ffa405eac

import pandas as pd
import re
import spacy
from rank_bm25 import BM25Okapi
from tqdm import tqdm
import pickle
import numpy as np
from gensim.models.fasttext import FastText
import os
import nmslib
import time

# Import data and rename column, ensure it is text
df_docs = df_docs.rename(columns={f'{text_column_name}': 'text', f'{id_column_name}': 'id'})
df_docs.text = df_docs.text.astype(str) 
df_docs.id = df_docs.id.astype(str) 

nlp = spacy.load(spacy_nlp_model)
text_list = df_docs.text.str.lower().values
tok_text=[] # for our tokenised corpus

print("Tokenizing new data...", flush = True)

# Tokenising using SpaCy:
for doc in tqdm(nlp.pipe(text_list, disable=["tagger", "parser","ner", "lemmatizer"])):
  tok = [t.text for t in doc if (t.is_ascii and not t.is_punct and not t.is_space)]
  tok_text.append(tok)

print("Loading FastText model...")

# Load fasttext model
ft_model = FastText.load('models/_fasttext_' + modelname + '_.model') #load

# BM25Okapi for searching
bm25 = BM25Okapi(tok_text)

print("Creating vectors...")

# Create vectors
weighted_doc_vects = []

for i,doc in (enumerate(tok_text)):
  doc_vector = []
  for word in doc:
    vector = ft_model[word]
    weight = (bm25.idf[word] * ((bm25.k1 + 1.0)*bm25.doc_freqs[i][word])) /    (bm25.k1 * (1.0 - bm25.b + bm25.b *(bm25.doc_len[i]/bm25.avgdl))+bm25.doc_freqs[i][word])
    weighted_vector = vector * weight
    doc_vector.append(weighted_vector)
  doc_vector_mean = np.mean(doc_vector,axis=0)
  weighted_doc_vects.append(doc_vector_mean)

# Save vectors
pickle.dump(weighted_doc_vects, open( "models/weighted_doc_vects_" + searchname +"_.p", "wb" ) ) #save the results to disc

# create a matrix from our document vectors
data = np.vstack(weighted_doc_vects)

# initialize a new index, using a HNSW index on Cosine Similarity
index_nms = nmslib.init(method='hnsw', space='cosinesimil')
index_nms.addDataPointBatch(data)
index_nms.createIndex({'post': 2}, print_progress=True)

print("Indexing whoosh...")

# http://jaympatel.com/2020/08/how-to-do-full-text-searching-in-python-using-whoosh-library/
from whoosh.fields import Schema, TEXT, ID
from whoosh import index
import os, os.path
from whoosh import index
from whoosh import qparser
from whoosh.qparser import QueryParser

schema = Schema(path=ID(stored=True), content=TEXT(stored = True))

#Now, we will use the schema to initialize a Whoosh index in the above directory.
ix = index.create_in("models", schema)
writer = ix.writer()

#Lastly, let us fill this index with the data from the dataframe.
for i in range(len(df_docs)):
    writer.add_document(content=str(df_docs.text.iloc[i]),
                    path=str(df_docs.id.iloc[i]))
writer.commit()

# https://stackoverflow.com/questions/19477319/whoosh-accessing-search-page-result-items-throws-readerclosed-exception
# http://annamarbut.blogspot.com/2018/08/whoosh-pandas-and-redshift-implementing.html
# https://ai.intelligentonlinetools.com/ml/search-text-documents-whoosh/
def index_search(dirname, search_fields, search_query, return_results_count):
    ix = index.open_dir(dirname)
    schema = ix.schema
    og = qparser.OrGroup.factory(0.9)
    mp = qparser.MultifieldParser(search_fields, schema, group = og)
    q = mp.parse(search_query)
    with ix.searcher() as s:
        results = s.search(q, terms=True, limit = return_results_count)
        print("Completing Whoosh Search")
        if len(results) == 0:
            tmp_df = pd.DataFrame(columns=['path'])
        else:
            #[print(hit) for hit in results]
            tmp_df = pd.concat([pd.DataFrame([[hit['path']]], columns=['path']) for hit in results], ignore_index=True)
    return(tmp_df)
      






print("Models loaded, vectors created for data and is ready for searching.")
  

search_query="sudsdsdf"
