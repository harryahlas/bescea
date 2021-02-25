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

#for i in range(len(df_docs)):
for i in range(0,100):
    writer.add_document(content=str(df_docs.text.iloc[i]),
                    path=str(df_docs.id.iloc[i]))
writer.commit()


# https://stackoverflow.com/questions/19477319/whoosh-accessing-search-page-result-items-throws-readerclosed-exception
# http://annamarbut.blogspot.com/2018/08/whoosh-pandas-and-redshift-implementing.html
# https://ai.intelligentonlinetools.com/ml/search-text-documents-whoosh/
def index_search(dirname, search_fields, search_query):
    ix = index.open_dir(dirname)
    schema = ix.schema
    
    og = qparser.OrGroup.factory(0.9)
    mp = qparser.MultifieldParser(search_fields, schema, group = og)

    
    q = mp.parse(search_query)
    
    
    with ix.searcher() as s:
        results = s.search(q, terms=True, limit = return_results_count)
        print("Completing Whoosh Search")
        tmp_df = pd.concat([pd.DataFrame([[hit['path']]], columns=['path']) for hit in results], ignore_index=True)
        return(tmp_df)
        
x = index_search("models", ['content'], u"long story short")

#results_dict = index_search("models", ['content'], u"nevermore guitar")
results = index_search("models", ['content'], u"andy the sneap guitar tone")
results[0]

dfx = pd.concat([pd.DataFrame([[hit['Text'],hit['Title']]], columns=col_list) for hit in results_dict],ignore_index=True)
dfx = pd.concat([pd.DataFrame([[hit['Text'],hit['Title']]], columns=col_list) for hit in index_search("models", ['content'], u"nevermore guitar")],ignore_index=False)
