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

# Variables
searchname = "sample_search"
csv_file_location = "data/sneap_sample_text.csv"

# Create models directory
if not os.path.exists('models'):
    os.makedirs('models')

# Import data and rename column, ensure it is text
df = pd.read_csv(csv_file_location)
df.text = df.text.astype(str) 

nlp = spacy.load("en_core_web_sm")
text_list = df.text.str.lower().values
tok_text=[] # for our tokenised corpus

# Tokenising using SpaCy:
for doc in tqdm(nlp.pipe(text_list, disable=["tagger", "parser","ner"])):
  tok = [t.text for t in doc if (t.is_ascii and not t.is_punct and not t.is_space)]
tok_text.append(tok)

# BM25Okapi for searching
bm25 = BM25Okapi(tok_text)

# Build fasttext model
ft_model = FastText(
  sg=1, # use skip-gram: usually gives better results
  size=100, # embedding dimension (default)
  window=10, # window size: 10 tokens before and 10 tokens after to get wider context
  min_count=2, # only consider tokens with at least n occurrences in the corpus
  negative=15, # negative subsampling: bigger than default to sample negative examples more
  min_n=2, # min character n-gram
  max_n=5 # max character n-gram
)

# Build Vocabulary
ft_model.build_vocab(tok_text) # tok_text is our tokenized input text - a list of lists relating to docs and tokens respectivley

# Train fasttext
ft_model.train(
  tok_text,
  epochs=1,
  total_examples=ft_model.corpus_count, 
  total_words=ft_model.corpus_total_words)

# save/load
ft_model.save('models/_fasttext_' + searchname + '_.model') #save
ft_model = FastText.load('models/_fasttext_' + searchname + '_.model') #load

# Most similar words
#ft_model.wv.most_similar("guitar", topn=20, restrict_vocab=5000)

weighted_doc_vects = []

# Create vectors
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
pickle.dump( weighted_doc_vects, open( "models/weighted_doc_vects_" + searchname +"_.p", "wb" ) ) #save the results to disc

# create a matrix from our document vectors
data = np.vstack(weighted_doc_vects)

# initialize a new index, using a HNSW index on Cosine Similarity
index = nmslib.init(method='hnsw', space='cosinesimil')
index.addDataPointBatch(data)
index.createIndex({'post': 2}, print_progress=True)


def besceaSearch(query_text):
  input = 'query_text'.lower().split()
  query = [ft_model[vec] for vec in input]
  query = np.mean(query,axis=0)
  t0 = time.time()
  ids, distances = index.knnQuery(query, k=10)
  t1 = time.time()
  print(f'Searched {df.shape[0]} records in {round(t1-t0,4) } seconds \n')
  for i,j in zip(ids,distances):
    print(round(j,2))
  print(df.text.values[i])


print("Documents ready for searching")
  
