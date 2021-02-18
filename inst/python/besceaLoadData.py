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

nlp = spacy.load(spacy_nlp_model)
text_list = df_docs.text.str.lower().values
tok_text=[] # for our tokenised corpus

# Tokenising using SpaCy:
for doc in tqdm(nlp.pipe(text_list, disable=["tagger", "parser","ner"])):
  tok = [t.text for t in doc if (t.is_ascii and not t.is_punct and not t.is_space)]
  tok_text.append(tok)

# Load fasttext model
ft_model = FastText.load('models/_fasttext_' + modelname + '_.model') #load

# BM25Okapi for searching
bm25 = BM25Okapi(tok_text)

# # Load BM25
# with open("models/bm25_" + modelname +"_.p", 'rb') as pickle_file:
#     bm25 = pickle.load(pickle_file)

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
index = nmslib.init(method='hnsw', space='cosinesimil')
index.addDataPointBatch(data)
index.createIndex({'post': 2}, print_progress=True)

print("Models loaded, vectors created for data and is ready for searching.")
  
