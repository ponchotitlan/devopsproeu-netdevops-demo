# devopsproeu-bgp
## Example NSO service for BGP provisioning. Demo for DevOpsPro Europe 2025 🇱🇹🇪🇺
### Session "Taming your Data Networks with the Power of NetDevOps"

This is a service for the Cisco Crossworks Network Services Orchestrator (NSO) intended for the provisioning of BGP configurations in target Cisco IOSXR devices.

## Usage

```
module: devopsproeu-bgp
  +--rw devopsproeu-bgp* [device]
     +--rw device       -> /ncs:devices/device/name
     +--rw local-as?    uint32
     +--rw neighbors* [address remote-as]
        +--rw address      inet:ipv4-address
        +--rw remote-as    uint32
        +--rw networks* [prefix]
           +--rw prefix    inet:ipv4-prefix
```

A cURL request for provisioning using the RESTCONF interface looks like the following:

```
curl --location --request PATCH 'http://localhost:8082/restconf/data' \
--header 'Accept: application/yang-data+json' \
--header 'Content-Type: application/yang-data+json' \
--header 'Authorization: Basic YWRtaW46YWRtaW4=' \
--data '{
  "data": {
    "devopsproeu-bgp:devopsproeu-bgp": [
      {
        "device": "ciscolive-iosxr-dummy-01",
        "local-as": 65004,
        "neighbors": [
          {
            "address": "182.0.2.2",
            "remote-as": 65005,
            "networks": [
              {
                "prefix": "172.168.1.0/24"
              }
            ]
          },
          {
            "address": "205.0.113.1",
            "remote-as": 65006,
            "networks": [
              {
                "prefix": "198.178.1.0/24"
              }
            ]
          }
        ]
      },
      {
        "device": "ciscolive-iosxr-dummy-02",
        "local-as": 65003,
        "neighbors": [
          {
            "address": "193.0.113.1",
            "remote-as": 65004,
            "networks": [
              {
                "prefix": "178.145.1.0/24"
              }
            ]
          }
        ]
      }
    ]
  }
}
'
```