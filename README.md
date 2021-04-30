# weechat

Dusty Mabe's weechat config that runs in tmux via systemd in
a container.

### For deploying to a Fedora CoreOS node:

Create the ignition config:

```
cat weechat.bu | butane --pretty --strict > weechat.ign
```

## On QEMU

```
chcon --verbose unconfined_u:object_r:svirt_home_t:s0 ./weechat.ign
virt-install --import --name weechat                        \
   --cpu host-passthrough --ram 2048 --vcpus 2              \
   --boot menu=on,useserial=on --accelerate --graphics none \
   --force --network bridge=virbr0,model=virtio             \
   --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${PWD}/weechat.ign" \
   --disk backing_store=/var/b/images/fedora-coreos-34.20210427.1.0-qemu.x86_64.qcow2,size=15
```
