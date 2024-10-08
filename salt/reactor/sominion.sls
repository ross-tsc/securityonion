#!py

# Copyright Security Onion Solutions LLC and/or licensed to Security Onion Solutions LLC under one
# or more contributor license agreements. Licensed under the Elastic License 2.0 as shown at
# https://securityonion.net/license; you may not use this file except in compliance with the
# Elastic License 2.0.

import logging
import salt.client
local = salt.client.LocalClient()

def run():

  vm_name = data['name']
  logging.error("sominion reactor: start for: %s " % vm_name)

  r = local.cmd(vm_name, 'state.apply', ['setup.virt.sominion'])

  logging.error("sominion reactor: end for: %s " % vm_name)

  return {}