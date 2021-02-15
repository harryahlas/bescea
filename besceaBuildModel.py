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

# # Variables specified in R
# searchname = "sample_search"
# csv_file_location = "data/sneap_sample_text.csv"
# return_results_count = 10

# Create models directory
if not os.path.exists('models'):
    os.makedirs('models')

# Import data and rename column, ensure it is text
#df = pd.read_csv(csv_file_location, encoding = 'iso-8859-1')
df = df.rename(columns={f'{text_column_name}': 'text', f'{id_column_name}': 'id'})
df.text = df.text.astype(str) 

nlp = spacy.load(spacy_nlp_model) # defaults to "en_core_web_sm"
text_list = df.text.str.lower().values
tok_text=[] # for our tokenised corpus

# Tokenising using SpaCy:
for doc in tqdm(nlp.pipe(text_list, disable=["tagger", "parser","ner"])):
  tok = [t.text for t in doc if (t.is_ascii and not t.is_punct and not t.is_space)]
  tok_text.append(tok)

# # BM25Okapi for searching
# bm25 = BM25Okapi(tok_text)
# 
# # Save BM25 model
# pickle.dump(bm25, open( "models/bm25_" + modelname +"_.p", "wb" ) ) #save the results to disc

# Build fasttext model
ft_model = FastText(
  sg=1, # use skip-gram: usually gives better results
  size=100, # embedding dimension (default)
  window=10, # window size: 10 tokens before and 10 tokens after to get wider context
  min_count=min_fasttext_word_count, # only consider tokens with at least n occurrences in the corpus
  negative=15, # negative subsampling: bigger than default to sample negative examples more
  min_n=2, # min character n-gram
  max_n=5 # max character n-gram
)

# Build Vocabulary
ft_model.build_vocab(tok_text) # tok_text is our tokenized input text - a list of lists relating to docs and tokens respectivley

# Train fasttext
ft_model.train(
  tok_text,
  epochs=fasttext_epochs,
  total_examples=ft_model.corpus_count, 
  total_words=ft_model.corpus_total_words)

# save fasttext model
ft_model.save('models/_fasttext_' + modelname + '_.model') #save

print("\nModel _fasttext_" + modelname + ".model has been built and stored in the 'models' folder.")

# Most similar words
#ft_model.wv.most_similar("guitar", topn=20, restrict_vocab=5000)
