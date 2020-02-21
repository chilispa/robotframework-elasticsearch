*** Settings ***
Library             ../src/RobotFrameworkElasticSearchLibrary/RobotFrameworkElasticSearchLibrary.py

*** Variables ***
${EXPECTED_DOCUMENT}=           { "id": "id", "name": "test_elastic"}
${URL}=                         elasticsearch
${ALIAS}=                       alias_test_elasticsearch
${INDEX}=                       index_test_elastic
${DOC_TYPE}=                    doc_test_elastic
${DOCUMENT_ID}=                 id_test_elastic
${NAME}=                        name_test_elastic

*** Test Cases ***
Test Get Document By Id From Elasticsearch
    Connect Elasticsearch               url=${URL}      alias=${ALIAS}
    ${document}=                        Get Document By Id From Elasticsearch               index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}
    Should Be Equal                     ${document['_source']['id']}      ${DOCUMENT_ID}
    Should Be Equal                     ${document['_source']['name']}    ${NAME}
    Disconnect From Elastic Search        alias=${ALIAS}

Test Drop Document From Elasticsearch
    Connect Elasticsearch               url=${URL}      alias=${ALIAS}
    Drop From Elasticsearch By Id       index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}
    ${document}=                        Get Document By Id From Elasticsearch               index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}
    ${expected}=                        Create Dictionary
    Should Be Equal                     ${document}    ${expected}
    Disconnect From Elastic Search        alias=${ALIAS}

#Test Save Document To Elasticsearch
#    Connect Elasticsearch                               url=${URL}      alias=${ALIAS}
#
#    Save Document To Elasticsearch                      index=${INDEX}  doc_type=${DOC_TYPE}    _id=${DOCUMENT_ID}      body
#    Disconnect To Elastic Search                        alias=${ALIAS}