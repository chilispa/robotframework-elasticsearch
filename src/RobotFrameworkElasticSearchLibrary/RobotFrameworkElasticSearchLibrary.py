from typing import Dict, Optional

from elasticsearch import Elasticsearch, NotFoundError
from robot.api import logger
from robot.api.deco import keyword
from robot.utils import ConnectionCache


class RobotFrameworkElasticSearchLibrary(object):

    def __init__(self) -> None:
        self._connection: Optional[Elasticsearch] = None
        self._cache = ConnectionCache()

    @property
    def connection(self) -> Elasticsearch:
        if self._connection is None:
            raise RuntimeError('There is no open connection to Elasticsearch.')
        return self._connection

    @keyword("Connect Elasticsearch")
    def connect_elasticsearch(self, url: str, alias: str):
        try:
            self._connection = Elasticsearch([url])
            return self._cache.register(self._connection, alias=alias)
        except Exception as e:
            raise Exception(f'Connect to Elasticsearch error: {e}')

    @keyword("Disconnect Elasticsearch")
    def disconnect_elasticsearch(self, alias: str = None) -> None:
        if alias:
            self._connection = self._cache.switch(alias)
            self._connection = None
        self._connection = None

    @keyword("Save Document To Elasticsearch")
    def save_document_to_elasticsearch(self, index: str, doc_type: str, _id: str, body: dict) -> None:
        self.connection.index(index=index, doc_type=doc_type, id=_id, body=body)

    @keyword("Get Document By Id From Elasticsearch")
    def get_document_by_id_from_elasticsearch(self, index: str, doc_type: str, _id: str) -> Dict:
        try:
            data = self.connection.get(index=index, doc_type=doc_type, id=_id)
            return data
        except NotFoundError as e:
            logger.debug(f"Not found document from ElasticSearch with _id: {_id}")
            return {}
        except Exception as e:
            logger.debug(f"Exception {e} raised working with Elasticsearch on "
                         f"{self.connection.host} and {self.connection.port}")
            raise

    @keyword("Get Document By Filter From Elasticsearch")
    def get_document_by_filter_from_elasticsearch(self, index: str, body: str) -> Dict:
        results = self.search_from_elasticsearch(index=index, body=body)
        if results:
            return results[0]
        return {}

    @keyword("Search From Elasticsearch")
    def search_from_elasticsearch(self, index: str, body: str) -> Dict:
        try:
            result = self.connection.search(index=index, body=body)
            return self._get_hits(result)
        except Exception as e:
            logger.debug(f"Exception {e} raised working with Elasticsearch on "
                         f"{self.connection.host} and {self.connection.port}")
            raise

    @keyword("Drop From Elasticsearch By Id")
    def drop_from_elasticsearch_by_id(self, index: str, doc_type: str, _id: str):
        try:
            return self.connection.delete(index=index, doc_type=doc_type, id=_id)
        except NotFoundError as e:
            return None
        except Exception as e:
            logger.debug(f"Exception {e} raised working with Elasticsearch on "
                         f"{self.connection.host} and {self.connection.port}")
            raise

    @keyword("Drop From Elasticsearch By Query")
    def drop_from_elasticsearch_by_query(self, index: str, body: str):
        try:
            return self.connection.delete_by_query(index=index, body=body)
        except NotFoundError as e:
            return None
        except Exception as e:
            logger.debug(f"Exception {e} raised working with Elasticsearch on "
                         f"{self.connection.host} and {self.connection.port}")
            raise

    @keyword("Create Term Query Filter")
    def create_term_query_filter(self, field: str, value: str) -> dict:
        query = {
            "query": self.create_term_filter(field=field, value=value)
        }
        return query

    @keyword("Create Must Query Filter")
    def create_must_query_filter(self, dictionary: dict) -> dict:
        _must = []
        for key, value in dictionary.items():
            _must.append(self.create_term_filter(field=key, value=value))
        query = {
            "query": {
                "bool": {
                    "must": _must
                }
            }
        }
        return query

    @keyword("Create Term Filter")
    def create_term_filter(self, field: str, value: str):
        return {
            "term": {
                f'{field}.keyword': value
            }
        }

    @classmethod
    def _get_hits(cls, response: dict):
        if response:
            hits = response.get('hits', {})
            if hits:
                return hits.get('hits', [])
        return []
