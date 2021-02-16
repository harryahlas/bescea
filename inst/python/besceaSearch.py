# Search function
# Prior to running this, a model must first be loaded and vectors must first be built for documents

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

# Search function
def besceaSearch(query_text, return_results_count):
  output_list = []
  input = query_text.lower().split()
  query = [ft_model[vec] for vec in input]
  query = np.mean(query,axis=0)
  t0 = time.time()
  ids, distances = index.knnQuery(query, k=return_results_count)
  t1 = time.time()
  print(f'Searched {df_docs.shape[0]} records in {round(t1-t0,4) } seconds \n')
  for i,j in zip(ids,distances):
    output_id = df_docs.id[i]
    output_text = df_docs.text.values[i]
    output_score = round(j,4)
    output_list.append([output_id, output_text, output_score])
  output_df = pd.DataFrame(output_list, columns = ['id', 'text', 'score'])   
  return(output_df)


