*** Settings ***
Library     agilis_robot.library
Library     String
Library     BuiltIn
Library     Dialogs
Library     DateTime
Documentation  Validate L3 interface state and configuration

*** Keywords ***
# Define user defined keywords if needed

*** Variables ***

${DUT}  West-Leaf-1
${INTERFACE}  loopback0
${ADMIN_STATE}  up
${IP_ADDR}  192.168.0.7
${NET_MASK}  32

*** Test Cases ***

1. Connect to Device
	[Documentation]  Load the testbed file and connect to the DUT.
    load testbed from environment variables
    connect to device "${DUT}"
	Log  Connect to device - ${DUT} - SUCCESSFULL.
	
2. Obtain the running Configuration of the L3-Interface
    [Documentation]  Obtain the running Configuration of the L3-Interface.
	run "Show run interface ${INTERFACE}"

3. Validate the Layer-3 interface state
    [Documentation]  Validate the interface state is "admin up"
    ${status}=  Run Keyword and Return Status  run parsed json "show interface ${INTERFACE}" and assert key "state" equals "${ADMIN_STATE}"
    Run Keyword If  '${status}' == 'False'  FAIL  The interface ${INTERFACE} is NOT in UP state
    Log  The interface ${INTERFACE} state is UP state.

4. Validate the Layer-3 interface configuration details
    [Documentation]  validate the Layer-3 interface configuration details
    ${CFG_IP_ADDR}=  agilis_robot.library.basic.parsing.get parsed "eth_ip_addr"
    ${CFG_NET_MASK}=  agilis_robot.library.basic.parsing.get parsed "eth_ip_mask"
    ${status}=  Run Keyword And Return Status  should be true  '${IP_ADDR}' == '${CFG_IP_ADDR}'
	Log  '${IP_ADDR}' == '${CFG_IP_ADDR}'
    Run Keyword If  '${status}' == 'False'  FAIL  The interface %{INTERFACE} is not configured with the right IP ${IP_ADDR}
    Log  user The interface %{INTERFACE} is not configured with the right IP %{IP_ADDR}
	${status}=  Run Keyword And Return Status  should be true  ${NET_MASK} == ${CFG_NET_MASK}
	Log  ${NET_MASK} == ${CFG_NET_MASK}
    Run Keyword If  '${status}' == 'False'  FAIL  The interface ${INTERFACE} is not configured with the right NET_MASK ${NET_MASK}
    Log  user The interface ${INTERFACE} is configured with the right NET_MASK ${NET_MASK}
	
