*** Settings ***
Library     CXTA
Library     Collections
Resource    cxta.robot

Documentation  Validate Jumbo MTU

*** Keywords ***

*** Variables ***

${DUT}  West-Leaf-1
${INTERFACE}  eth1/49
@{INTERFACES}  eth1/49  eth1/48  eth1/47  eth1/46  eth1/45  eth1/44  
${MTU}  9216

*** Test Cases ***

1. Connect to Device
    [Documentation]  Load the testbed file and connect to the DUT.
    load testbed
    connect to device "${DUT}" via "ssh"
    Log  Connect to device - "${DUT}" - SUCCESSFUL.
    
2. Obtain the Running Configuration for the interface.
    [Documentation]  Obtain the Running Configuration for the interface.
    run "show run interface ${INTERFACE}"

3. Validate MTU configured on a specific interface (Regex)
    [Documentation]  verify the interface is configured for Jumbo MTU using Regex
    run "show run interface ${INTERFACE}"
    output contains "mtu 9216"
    run "show interface ${INTERFACE}"
    output contains "MTU ${MTU} bytes"

4. Validate MTU on Multiple Interfaces
    [Documentation]  Validate multiple interfaces for MTU on list
    FOR  ${INTERFACE}  IN  @{INTERFACES}
        run "show run interface ${INTERFACE}"
        output contains "mtu 9216"
        run "show interface ${INTERFACE}"
        output contains "MTU ${MTU} bytes"
        Set Test Message  MTU for ${INTERFACE} is ${MTU}
    END



