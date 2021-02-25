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
from gensim import corpora
from gensim.summarization import bm25


# Search function
def besceaSearch(query_text, return_results_count, fasttext_weight):
  
  # FastText search
  output_list = []
  input = query_text.lower().split()
  query = [ft_model[vec] for vec in input]
  query = np.mean(query,axis=0)
  t0 = time.time()
  ids, distances = index_nms.knnQuery(query, k=return_results_count)
  t1 = time.time()
  print(f'Searched {df_docs.shape[0]} records in {round(t1-t0,4) } seconds \n')
  for i,j in zip(ids,distances):
    output_id = df_docs.id[i]
    output_text = df_docs.text.values[i]
    output_score = round(j,4)
    output_list.append([output_id, output_text, output_score])

  output_fasttext = pd.DataFrame(output_list, columns = ['id', 'text', 'score']) 
  output_fasttext = output_fasttext[['id', 'score']]
  output_fasttext['fasttext_rank'] = np.arange(len(output_fasttext))
  #return(output_fasttext)

  t2 = time.time()
  print(f'Completed FastText in {round(t2-t0,4) } seconds \n')
  
  # whoosh search
  output_whoosh = index_search("models", ['content'], query_text, return_results_count) #u"long story short"
  output_whoosh = output_whoosh.rename(columns = {"path": "id"})
  output_whoosh['whoosh_rank'] = np.arange(len(output_whoosh))
  
  t3 = time.time()
  print(f'Completed whoosh search in {round(t3-t2,4) } seconds \n')

  # Join FastText and whoosh data frames
  fasttext_multiplier = (1 - fasttext_weight) * 2
  whoosh_multiplier =  fasttext_weight * 2
  output_df = pd.merge(output_fasttext, output_whoosh, how = "outer", on='id')
  output_df['whoosh_rank'] = output_df['whoosh_rank'].fillna(return_results_count)
  output_df['fasttext_rank'] = output_df['fasttext_rank'].fillna(return_results_count)
  output_df['total_rank'] = (output_df['fasttext_rank'] * fasttext_multiplier) + (output_df['whoosh_rank'] * whoosh_multiplier)
  output_df = output_df.sort_values(by=['total_rank'])
  output_df = pd.merge(output_df, df_docs[['id', 'text']], how = 'left', on = 'id')

  t4 = time.time()
  print(f'Joined data in {round(t4-t3,4) } seconds \n')
  




  # # bm25 search
  # texts = [doc.split() for doc in df_docs.text] # no preprocessing
  # dictionary = corpora.Dictionary(texts)
  # corpus = [dictionary.doc2bow(text) for text in texts]
  # bm25_obj = bm25.BM25(corpus)
  # query_doc = dictionary.doc2bow(query_text.split())
  # scores = bm25_obj.get_scores(query_doc)
  # df_docs['bmf_scores'] = scores
  # output_bm25 = df_docs.sort_values(by=['bmf_scores'], ascending = False)
  # output_bm25['bm25_rank'] = np.arange(len(output_bm25))
  # output_bm25 = output_bm25[output_bm25['bm25_rank'] <= return_results_count]
  # output_bm25 = output_bm25[['bmf_scores', 'bm25_rank', 'id']]
  # 
  # t3 = time.time()
  # print(f'Completed bm25 in {round(t3-t2,4) } seconds \n')
  # 
  # # Join FastText and bm25 data frames
  # fasttext_multiplier = (1 - fasttext_weight) * 2
  # bm25_multiplier =  fasttext_weight * 2
  # output_df = pd.merge(output_fasttext, output_bm25, how = "outer", on='id')
  # output_df['bm25_rank'] = output_df['bm25_rank'].fillna(return_results_count)
  # output_df['fasttext_rank'] = output_df['fasttext_rank'].fillna(return_results_count)
  # output_df['total_rank'] = (output_df['fasttext_rank'] * fasttext_multiplier) + (output_df['bm25_rank'] * bm25_multiplier)
  # output_df = output_df.sort_values(by=['total_rank'])
  # output_df = pd.merge(output_df, df_docs[['id', 'text']], how = 'left', on = 'id')
  # 
  # t4 = time.time()
  # print(f'Joined data in {round(t4-t3,4) } seconds \n')

  return(output_df)
