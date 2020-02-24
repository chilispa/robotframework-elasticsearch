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
    ${expected}=                                    Create Dictionary       id=${DOCUMENT_ID}           name=${NAME}
    Connect Elasticsearch                           url=${URL}              alias=${ALIAS}
    Check Expected Document In Elasticsearch        index=${INDEX}          doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}          expected_document=${expected}
    Disconnect Elasticsearch                        alias=${ALIAS}

Test Get Document By Filter To Elasticsearch
    ${dictionary}=          Create Dictionary               name=${NAME}
    ${query}=               Create Must Query Filter        dictionary=${dictionary}
    ${expected}=            Create Dictionary               id=${DOCUMENT_ID}   name=${NAME}
    Connect Elasticsearch                                   url=${URL}          alias=${ALIAS}
    Check Expected Document In Elasticsearch                index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}      expected_document=${expected}
    Disconnect Elasticsearch                                alias=${ALIAS}

Test Save Document To Elasticsearch
    ${expected}=                                    Create Dictionary   id=${DOCUMENT_ID}       name=${NAME}
    Connect Elasticsearch                           url=${URL}          alias=${ALIAS}
    Save New Test Document In Elasticsearch         index=${INDEX}      doc_type=${DOC_TYPE}    _id=${DOCUMENT_ID}      name=${NAME}
    Check Expected Document In Elasticsearch        index=${INDEX}      doc_type=${DOC_TYPE}    _id=${DOCUMENT_ID}      expected_document=${expected}
    Disconnect Elasticsearch                        alias=${ALIAS}

Test Drop Document From Elasticsearch
    ${expected}=                                    Create Dictionary
    Connect Elasticsearch                           url=${URL}      alias=${ALIAS}
    Save New Test Document In Elasticsearch         index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}         name=${NAME}
    Drop From Elasticsearch By Id                   index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}
    Check Expected Document In Elasticsearch        index=${INDEX}      doc_type=${DOC_TYPE}        _id=${DOCUMENT_ID}         expected_document=${expected}
    Disconnect Elasticsearch                        alias=${ALIAS}

*** Keywords ***
Save New Test Document In Elasticsearch
    [Arguments]             ${index}                ${doc_type}         ${_id}        ${name}
    ${document}=            Create Dictionary       id=${_id}           name=${name}
    Save Document To Elasticsearch                  index=${index}      doc_type=${doc_type}        _id=${_id}      body=${document}

Check Expected Document In Elasticsearch
    [Arguments]             ${index}            ${doc_type}         ${expected_document}        ${_id}=${None}        ${query}=${None}
    ${document}=            Run Keyword If     '${query}'=='${None}'  Get Document By Id From Elasticsearch             index=${index}     doc_type=${doc_type}    _id=${id}
    ...                     ELSE               Get Document By Filter From Elasticsearch         index=${index}     body=${query}
    ${source}=              Set Variable If     "${document}"!="{}"         ${document['_source']}          ${document}
    Should Be Equal         ${source}           ${expected_document}