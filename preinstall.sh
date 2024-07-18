#!/bin/bash
 
apt-get update
apt-get dist-upgrade
update-kernel

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

touch /etc/audit/rules.d/20-fstec-reccommend.rules
cat > /etc/audit/rules.d/20-fstec-reccommend.rules << EOF
-w /var/log -p w -k var_log_changes
-w /etc/group -p wa -k etcgroup
-w /etc/passwd -p wa -k etcpasswd
-w /etc/gshadow -k etcgroup
-w /etc/shadow -k etcpasswd
-w /etc/security/opasswd -k opasswd
-w /etc/adduser.conf -k adduserconf
-w /etc/sudoers -p wa -k actions
-w /usr/bin/passwd -p x -k passwd_modification
-w /usr/bin/gpasswd -p x -k gpasswd_modification
-w /usr/sbin/groupadd -p x -k group_modification
-w /usr/sbin/groupmod -p x -k group_modification
-w /usr/sbin/addgroup -p x -k group_modification
-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/adduser -p x -k user_modification
-w /etc/login.defs -p wa -k login
-w /etc/securetty -p wa -k login
-w /var/log/faillog -p wa -k login
-w /var/log/lastlog -p wa -k login
-w /var/log/tallylog -p wa -k login
-a exit,always -F path=/usr/bin/myapp -F perm=x -k myapp_execution
-a exit,always -F arch=b64 -S execve -F uid=0 -k authentication_events
-a exit,always -F arch=b32 -S execve -F uid=0 -k authentication_events
-a exit,always -F arch=b64 -S bind -S connect -F success=0 -k network_events
-w /dev/bus/usb -p rwxa -k usb
EOF

shutdown -r now
