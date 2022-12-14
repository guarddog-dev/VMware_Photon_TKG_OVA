/*
	VMware Photon OS Variables File
	Created by 
		Russell Hamker
		Twitter -> @butch7903
*/

// VM Config Info
version = "0.25.0"
description = "GuardDog AI Photon Tanzu TKG Appliance"
vm_name = "photontkg-template.guarddog.lab"
vm_final_name = "photontkg.guarddog.lab"
iso_checksum = "2bb1f61d6809835a9562767d947612c4"
iso_url = "https://packages.vmware.com/photon/4.0/Rev2/iso/photon-minimal-4.0-c001795b8.iso"
numvcpus = "4"
ramsize = "8192"

// VMware Connect Credentials # needed to download Tanzu CLI
vmwuser = "<YourEmailHere@Domain.com>"
vmwpass = "<YourCustomerConnectPassword>"

// VM user Login Info
guest_username = "root"
guest_password = "VMware12345!"

// VMHOST Info
builder_host = "10.10.0.11"
builder_host_username = "root"
builder_host_password = "VMware12345!"
builder_host_datastore = "vsanDatastore"
builder_host_portgroup = "VM Network"

// VCSA Info
ovftool_deploy_vcenter = "10.10.0.100"
ovftool_deploy_vcenter_password = "VMware12345!"
ovftool_deploy_vcenter_username ="administrator@vsphere.local"

// OVA OVF Template Name
photon_ovf_template = "photon.xml.template"
