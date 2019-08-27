# ssh-agent, kwallet-pam, ssh-add, and ksshaskpass under Plasma
Auto-unlocking of SSH keys through KWallet had been broken for me for a while. I finally got around to fixing it, so just tossing this out there in case someone is in the same boat.

I’m on Arch Linux, but the steps should be the same on other distributions.

## Step 1: Install and configure kwallet-pam

`sudo pacman -S kwallet-pam kwalletmanager`

and load the modules from your /etc/pam.d/sddm:

```
#%PAM-1.0

auth            include         system-login
auth            optional        pam_kwallet5.so

account         include         system-login
password        include         system-login

session         include         system-login
session         optional        pam_kwallet5.so auto_start
```

This way, your KWallet is unlocked when you login. Note that your login and KWallet passwords must match, you must use Blowfish encryption for the wallet (not GPG), and the name of the wallet must be kdewallet (the default).

## Step 2: Start ssh-agent through a systemd user unit file

`touch ~/.config/systemd/user/ssh-agent.service`

```
[Unit]
Description=SSH key agent

[Service]
Type=forking
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -a $SSH_AUTH_SOCK

[Install]
WantedBy=basic.target
```
and enable the service with systemctl --user enable ssh-agent. Make sure you use WantedBy=basic.target and not WantedBy=default.target, as at least I had problems with ssh-agent not starting early enough with the latter.

## Step 3: Install and configure ksshaskpass

`sudo pacman -S ksshaskpass`

Then create /etc/profile.d/sshaskpass.sh with:

```
#!/bin/bash
export SSH_ASKPASS="/usr/bin/ksshaskpass"
```

This way, ksshaskpass, which will store your passphrase in your wallet, will be the preferred program to unlock your SSH keys.

## Step 4: Run ssh-add on Plasma start

Create ~/config/autostart-scripts/ssh-add.sh with:

```
#!/bin/sh

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

ssh-add < /dev/null
```

Setting SSH_AUTH_SOCK is necessary, since apparently .bashrc is not picked up. Make sure you make the script executable with chmod +x.

## Step 5: Export SSH_AUTH_SOCK also in ~/.bashrc

Make sure you have

```
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
```

also in .bashrc.
