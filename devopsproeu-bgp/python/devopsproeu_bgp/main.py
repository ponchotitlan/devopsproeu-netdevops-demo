# -*- mode: python; python-indent: 4 -*-
import ncs
from ncs.application import Service

class ServiceCallbacks(Service):
    @Service.create
    def cb_create(self, tctx, root, service, proplist):
        self.log.info('Service create(service=', service._path, ')')
        vars = ncs.template.Variables()
        template = ncs.template.Template(service)

        vars.add('DEVICE', service.device)
        vars.add('LOCAL-AS', service.local_as)
        
        for neighbour in service.neighbors:
            vars.add('REMOTE-ADRESS', neighbour.address)
            vars.add('REMOTE-AS', neighbour.remote_as)
            
            for network in neighbour.networks:
                vars.add('PREFIX', network.prefix)
                template.apply('devopsproeu-bgp-template', vars)

class Main(ncs.application.Application):
    def setup(self):
        self.register_service('devopsproeu-bgp-servicepoint', ServiceCallbacks)

    def teardown(self):
        self.log.info('Main FINISHED')
