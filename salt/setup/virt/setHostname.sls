# Copyright Security Onion Solutions LLC and/or licensed to Security Onion Solutions LLC under one
# or more contributor license agreements. Licensed under the Elastic License 2.0 as shown at 
# https://securityonion.net/license; you may not use this file except in compliance with the
# Elastic License 2.0.

{% from 'soinstall.map.jinja' import DATA %}

setHostname_{{grains.id.split("_") | first}}:
  network.system:
    - name: {{grains.id.split("_") | first}}
    - enabled: True
    - hostname: {{grains.id.split("_") | first}}
    - apply_hostname: True

create_pillar:
  event.send:
    - name: setup/so-minion
    - data:
        MAINIP: {{ DATA.MAINIP }}
        MNIC: {{ DATA.MNIC }}
        NODE_DESCRIPTION: '{{ DATA.NODE_DESCRIPTION }}'
        ES_HEAP_SIZE: {{ DATA.ES_HEAP_SIZE }}
        PATCHSCHEDULENAME: {{ DATA.PATCHSCHEDULENAME }}
        INTERFACE: {{ DATA.INTERFACE }}
        NODETYPE: {{ DATA.NODETYPE }}
        CORECOUNT: {{ DATA.CORECOUNT }}
        LSHOSTNAME: {{ DATA.LSHOSTNAME }}
        LSHEAP: {{ DATA.LSHEAP }}
        CPUCORES: {{ DATA.CPUCORES }}
        IDH_MGTRESTRICT: {{ DATA.IDH_MGTRESTRICT }}
        IDH_SERVICES: {{ DATA.IDH_SERVICES }}
        CPU: {{ DATA.CPU }}
        MEMORY: {{ DATA.MEMORY }}
        DISKS: {{ DATA.DISKS }}
        COPPER: {{ DATA.COPPER }}
        SFP: {{ DATA.SFP }}


# set event for firewall rules - so-firewall-minion

clean_sls_list:
  file.line:
    - name: /etc/salt/minion
    - match: 'sls_list:'
    - mode: delete

clean_setHostname:
  file.line:
    - name: /etc/salt/minion
    - match: '- setHostname'
    - mode: delete
    - onchanges:
      - file: clean_sls_list

set_highstate:
  file.replace:
    - name: /etc/salt/minion
    - pattern: 'startup_states: sls'
    - repl: 'startup_states: highstate'
    - onchanges:
      - file: clean_setHostname