*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    custom.py

*** Variables ***
${endpoint}    http://localhost:3000

*** Keywords ***
Request A Car Flow
    [Arguments]    ${is_disable}
    ${get_all_hop}=    GET  ${endpoint}/hopPoints
    ${all_hop}=    Set Variable    ${get_all_hop.json()}
    ${pickUp_hop}    ${dropOff_hop}    Get Pickup And Dropoff    ${all_hop}    ${is_disable}
    ${get_price}=    GET    ${endpoint}/prices    params=pickUpPointId=${pickUp_hop['id']}&droppOffPointId=${dropOff_hop['id']}
    ${price_hop}=    Set Variable    ${get_price.json()}
    Log To Console    Price is ${price_hop[0]['price']}
    [Return]    ${pickUp_hop}    ${dropOff_hop}

*** Test Cases ***
Verify Request A Car Flow that have disable as False
    ${pickUp_hop}    ${dropOff_hop}=    Request A Car Flow    False
    &{data}=    Create Dictionary    pickUpPointID=${${pickUp_hop['id']}}    droppOffPointID=${${dropOff_hop['id']}}
    ${post_hop}=    POST    ${endpoint}/trips    json=${data}
    Status Should Be    201    ${post_hop}

Verify Request A Car Flow that have disable as True
    ${pickUp_hop}    ${dropOff_hop}=    Request A Car Flow    True
    &{data}=    Create Dictionary    pickUpPointID=${${pickUp_hop['id']}}    droppOffPointID=${${dropOff_hop['id']}}
    ${post_hop}=    POST    ${endpoint}/trips    json=${data}
    Should Contain    ${post_hop}    { “errorCode”: “error_code”, “errorMessage”: “Error message here” }

Verify Request A Car Flow PickUp and DropOff is the same
    ${pickUp_hop}    ${dropOff_hop}=    Request A Car Flow    False
    &{data}=    Create Dictionary    pickUpPointID=${1}    droppOffPointID=${1}
    ${post_hop}=    POST    ${endpoint}/trips    json=${data}
    Should Contain    ${post_hop}    { “errorCode”: “error_code”, “errorMessage”: “Error message here” }
