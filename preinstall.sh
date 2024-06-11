#!/bin/bash
 
apt-get update
apt-get install system-config-printer 1c-preinstall 1c-preinstall-full nano x11vnc -y
x11vnc -storepasswd /etc/x11vnc.pass
touch /root/startvnc.sh
chmod +x /root/startvnc.sh
cat > /root/startvnc.sh << EOF
#!/bin/bash
/usr/bin/x11vnc -display :0 -dontdisconnect -notruecolor -noxfixes -shared -forever -rfbport 5900 -bg -rfbauth /etc/x11vnc.pass
EOF
sed '/greeter-wrapper=\/etc\/X11\/Xgreeter.lightdm/a display-setup-script = \/root\/startvnc.sh' /etc/lightdm/lightdm.conf > /etc/lightdm/lightdm_new.conf
mv /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
mv /etc/lightdm/lightdm_new.conf /etc/lightdm/lightdm.conf

shutdown -r now