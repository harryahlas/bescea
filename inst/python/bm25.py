from gensim import corpora
from gensim.summarization import bm25
import pandas as pd
import numpy as np
#df = pd.read_csv(csv_file_location, encoding = 'iso-8859-1')
#df = df.rename(columns={f'{text_column_name}': 'text', f'{id_column_name}': 'id'})
#df.text = df.text.astype(str) 

df = pd.DataFrame({
  'textid': ['a', 'b', 'c', 'd'], 
  'post_text': [
    'hello there, i am happy',
    'hi. this is fun. happiness all around. hello.',
    ' ',
    'what is this place?'
  ]})

#docs = df.post_text

query = "hi. this is fun. happiness all around. hello"

texts = [doc.split() for doc in df.post_text] # you can do preprocessing as removing stopwords
dictionary = corpora.Dictionary(texts)
corpus = [dictionary.doc2bow(text) for text in texts]
bm25_obj = bm25.BM25(corpus)
query_doc = dictionary.doc2bow(query.split())
scores = bm25_obj.get_scores(query_doc)
#best_docs = sorted(range(len(scores)), key=lambda i: scores[i])[-2:]


df['bmf_scores'] = scores
dfout = df.sort_values(by=['scores'], ascending = False) 
dfout['bm25_rank'] = np.arange(len(dfout))
dfout


# old
df['NewIndex'] = None # Create new column, with only None values

for indx, value in enumerate(best_docs):
    df['NewIndex'][value] = indx # Set index (List element number) to indx (Order in indices list)

dfout = df.sort_values(by=['NewIndex']) # Sort by new column




df[df.index.isin(best_docs)]
df[df.index.isin(best_docs)].sort_values(by=[best_docs]) 

df['List']=ListOfIndices
df.sort_values(by=['List'])


del(texts)
del(dictionary)
del(corpus)
del(bm25_obj)
del(query_doc)
del(scores)
del(best_docs)
