*** Settings ***
Documentation     DevOpsPro Europe 2025 🇱🇹🇪🇺 - Testing of BGP inventory provisioning.
...    Part of the session "Taming your Data Networks with the Power of NetDevOps"
...    Author: @ponchotitlan

Library    REST
Library    String
Library    OperatingSystem
Library    Collections
Library    JSONLibrary

# Regardless of the request type, set the same header
Suite Setup    Set my HTTP Request Header

*** Variables ***
${url_acl_service}    http://localhost:8080/restconf/data/devopsproeu-bgp:devopsproeu-bgp

*** Test Cases ***
⚙ Provision BGP inventory configurations ⚙
    [Documentation]    ⚙ Provision BGP inventory configurations ⚙
    ${bgp_inventory}   Get File   bgp-inventory.json
    Log    ${bgp_inventory}
    ${result}    PATCH    ${url_acl_service}    ${bgp_inventory}
    Log    ${result}
    # Should Be Equal As Strings    ${acl_cdb}    ${acl_expected}

*** Keywords ***
Set my HTTP Request Header
    [Documentation]    Set the headers for NSO REST requests
    Set Headers	{ "Authorization": "Basic YWRtaW46YWRtaW4="}
    Set Headers	{ "Accept": "application/yang-data+json"}
    Set Headers	{ "Content-type": "application/yang-data+json"}