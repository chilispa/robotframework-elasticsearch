*** Settings ***
Documentation       RobotFrameworkElasticSearch tests.

Library             ../src/RobotFrameworkElasticSearchLibrary/RobotFrameworkElasticSearchLibrary.py

*** Variables ***
${URL}=                elasticsearch
${ALIAS}=              alias_test_elasticsearch
${INDEX}=              index_test_elastic
${DOC_TYPE}=           doc_test_elastic
${DOCUMENT_ID}=        id_test_elastic
${NAME}=               name_test_elastic

*** Test Cases ***
Test Get Document By Id From Elasticsearch
    Connect Elasticsearch                           url=${URL}              alias=${ALIAS}
    ${expected}=                                    Create Dictionary       id=${DOCUMENT_ID}           name=${NAME}
    Check Expected Document In ElasticSearch        index=${INDEX}          doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}          expected_document=${expected}
    Disconnect Elasticsearch                        alias=${ALIAS}

Test Drop Document From Elasticsearch
    Connect Elasticsearch                           url=${URL}      alias=${ALIAS}
    Drop From Elasticsearch By Id                   index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}
    ${expected}=                                    Create Dictionary
    Check Expected Document In ElasticSearch        index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}          expected_document=${expected}
    Disconnect Elasticsearch                        alias=${ALIAS}

Test Save Document To Elasticsearch
    Connect Elasticsearch                           url=${URL}      alias=${ALIAS}
    ${document}=                                    Create Dictionary       id=${DOCUMENT_ID}           name=${NAME}
    Save Document To Elasticsearch                  index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}      body=${document}
    Check Expected Document In ElasticSearch        index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}      expected_document=${document}
    Disconnect Elasticsearch                        alias=${ALIAS}

Test Get Document By Filter To Elasticsearch
    Connect Elasticsearch                                   url=${URL}          alias=${ALIAS}
    ${dictionary}=          Create Dictionary               name=${NAME}
    ${query}=               Create Must Query Filter        dictionary=${dictionary}
    ${expected}=            Create Dictionary               id=${DOCUMENT_ID}   name=${NAME}
    Check Expected Document In ElasticSearch                index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}      expected_document=${expected}
    Disconnect Elasticsearch                                alias=${ALIAS}

*** Keywords ***
Check Expected Document In ElasticSearch
    [Arguments]             ${index}            ${doc_type}         ${expected_document}        ${_id}=${None}        ${query}=${None}
    ${document}=            Run Keyword If     '${query}'=='${None}'  Get Document By Id From Elasticsearch             index=${index}     doc_type=${doc_type}    _id=${id}
    ...                     ELSE               Get Document By Filter From Elasticsearch         index=${index}     body=${query}
    ${source}=              Set Variable If         "${document}"!="{}"         ${document['_source']}          ${document}
    Should Be Equal         ${source}           ${expected_document}


