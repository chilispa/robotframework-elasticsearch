from elasticsearch import Elasticsearch

HOST: str = "http://elasticsearch:9200"
INDEX_NAME: str = "index_test_elastic"
DOC_TYPE: str = "doc_test_elastic"
DOCUMENT_ID = "id_test_elastic"
NAME = "name_test_elastic"
DOCUMENT = {
    "id": DOCUMENT_ID,
    "name": NAME
}

elastic_search: Elasticsearch = Elasticsearch(hosts=[HOST])
elastic_search.index(index=INDEX_NAME, doc_type=DOC_TYPE, body=DOCUMENT, id=DOCUMENT_ID)
