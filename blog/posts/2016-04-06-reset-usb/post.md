---
title: Fix a non-responsive USB on Ubuntu 14.04
---

I use a wireless mouse that uses one of the usb ports on my machine. From time to time the usb stops responding. I am not what causes it but it can be fixed by rebinding the usb controller:

## Get a list of usb controllers

```
$ lspci | grep USB

00:14.0 USB controller: Intel Corporation 8 Series USB xHCI HC (rev 04)
00:1d.0 USB controller: Intel Corporation 8 Series USB EHCI #1 (rev 04)
```

## Rebind the usb controller

For my usb mouse, I know that I am using the xhci driver so I only rebind the relevant connector:

```
sudo su
echo -n '0000:00:14.0' | tee /sys/bus/pci/drivers/xhci_hcd/unbind
echo -n '0000:00:14.0' | tee /sys/bus/pci/drivers/xhci_hcd/bind
```

<!-- echo -n '0000:00:1d.0' | tee /sys/bus/pci/drivers/ehci-pci/unbind -->
<!-- echo -n '0000:00:1d.0' | tee /sys/bus/pci/drivers/ehci-pci/bind -->

The solution and related ones can be found at **[askubuntu][askubuntu]**

[askubuntu]: http://askubuntu.com/questions/645/how-do-you-reset-a-usb-device-from-the-command-line


