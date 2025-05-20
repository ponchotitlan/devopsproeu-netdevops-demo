*** Settings ***
Documentation     DevOpsPro Europe 2025 🇱🇹🇪🇺 - Testing of BGP inventory provisioning.
...    Part of the session "Taming your Data Networks with the Power of NetDevOps"
...    Author: @ponchotitlan

Library    REST
Library    String
Library    XML
Library    yaml
Library    OperatingSystem
Library    Collections
Library    JSONLibrary

Suite Setup    Set RESTCONF Request Parameters

*** Variables ***
${environment}    NA
${nso_address}    NA
${nso_auth}    NA
${nso_restconf_port}    NA
${bgp_inventory}    NA
${ENV_FILE}    environments.yaml
${URL_REST_CHECK}    http://_ADDRESS_PORT_/restconf/
${URL_BGP_DRYRUN}    http://_ADDRESS_PORT_/restconf/data?dry-run=native
${URL_BGP_COMMIT}    http://_ADDRESS_PORT_/restconf/data

*** Test Cases ***
🤖 Test RESTCONF reachability to NSO 🤖
    [Documentation]    Test RESTCONF reachability to NSO
    ${result}=    GET    ${URL_REST_CHECK}
    Log    ${result}
    Should Be Equal As Integers    ${result}[status]   200

🤖 DRY-RUN - Provision BGP inventory configurations 🤖
    [Documentation]    DRY-RUN: Provision BGP inventory configurations
    Log    ${URL_BGP_DRYRUN}
    Log    ${bgp_inventory}
    ${result}=    PATCH    ${URL_BGP_DRYRUN}    ${bgp_inventory}
    Log    Full body - ${result}
    Log    Dry-run Native Payload - ${result}[body][dry-run-result][native]
    Should Be Equal As Integers    ${result}[status]   200

🤖 COMMIT - Provision BGP inventory configurations 🤖
    [Documentation]    COMMIT: Provision BGP inventory configurations
    ${result}=    PATCH    ${URL_BGP_COMMIT}    ${bgp_inventory}
    Should Be Equal As Integers    ${result}[status]   204

*** Keywords ***
Set RESTCONF Request Parameters
    [Documentation]    Set the headers and URLs for the NSO RESTCONF requests
    Set NSO environment
    Set RESTCONF URLs
    Set RESTCONF Headers
    Set RESTCONF Body

Set NSO environment
    [Documentation]    Set the target NSO connectivity details based on the environment type
    ${env_value}=    Get Environment Variable    ENVIRONMENT    test
    Set Suite Variable    ${environment}    ${env_value}
    Log    Current environment - ${environment}
    ${yaml_envs}=  Get File  ${CURDIR}/${ENV_FILE}
    ${envs}=  yaml.Safe Load  ${yaml_envs}
    IF    '${environment}' == 'test'
        ${auth_value}=    Get Environment Variable    TEST_AUTH_HASH
        Set Suite Variable    ${nso_address}    ${envs}[environments][test][ip_address]
        Set Suite Variable    ${nso_restconf_port}    ${envs}[environments][test][restconf_port]
    ELSE
        ${auth_value}=    Get Environment Variable    PROD_AUTH_HASH
        Set Suite Variable    ${nso_address}    ${envs}[environments][production][ip_address]
        Set Suite Variable    ${nso_restconf_port}    ${envs}[environments][production][restconf_port]
    END
    Set Suite Variable    ${nso_auth}    ${auth_value}

Set RESTCONF URLs
    [Documentation]    Set the URLs for the NSO RESTCONF requests
    ${rest_check_replaced}=    Replace String    ${URL_REST_CHECK}    _ADDRESS_PORT_    ${nso_address}:${nso_restconf_port}
    ${bgp_dryrun_replaced}=    Replace String    ${URL_BGP_DRYRUN}    _ADDRESS_PORT_    ${nso_address}:${nso_restconf_port}
    ${bgp_commit_replaced}=    Replace String    ${URL_BGP_COMMIT}    _ADDRESS_PORT_    ${nso_address}:${nso_restconf_port}
    Set Suite Variable    ${URL_REST_CHECK}    ${rest_check_replaced}
    Set Suite Variable    ${URL_BGP_DRYRUN}    ${bgp_dryrun_replaced}
    Set Suite Variable    ${URL_BGP_COMMIT}    ${bgp_commit_replaced}

Set RESTCONF Headers
    [Documentation]    Set the headers for the NSO RESTCONF requests
    Set Headers	{ "Authorization": "Basic ${nso_auth}"}
    Set Headers	{ "Accept": "application/yang-data+json"}
    Set Headers	{ "Content-type": "application/yang-data+json"}

Set RESTCONF Body
    [Documentation]    Set the body payload for the NSO RESTCONF requests
    ${bgp_inventory_payload}=   Get File   ${CURDIR}/bgp-inventory.json
    Set Suite Variable    ${bgp_inventory}    ${bgp_inventory_payload}