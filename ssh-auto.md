# ssh-agent, kwallet-pam, ssh-add, and ksshaskpass under Plasma
Auto-unlocking of SSH keys through KWallet had been broken for me for a while. I finally got around to fixing it, so just tossing this out there in case someone is in the same boat.

I’m on Arch Linux, but the steps should be the same on other distributions.

## Step 1: Install Required Programs

`sudo pacman -S kwallet-pam kwalletmanager ksshaskpass`

## Step 2: Configure sddm

Past or uncomment these lines in this file.

`vim /etc/pam.d/sddm`

```
auth            optional        pam_kwallet5.so
session         optional        pam_kwallet5.so auto_start
```

This way, your KWallet is unlocked when you login. Note that your login and KWallet passwords must match, you must use Blowfish encryption for the wallet (not GPG), and the name of the wallet must be kdewallet (the default).

## Step 3: Configure ssh-agent

Start ssh-agent through a systemd user unit file.

`mkdir -p ~/.config/systemd/user`
`vim ~/.config/systemd/user/ssh-agent.service`

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

`systemctl --user enable ssh-agent`

## Step 4: Configure ksshaskpass

Store the ssh passphrase in the wallet.

`mkdir -p ~/.config/plasma-workspace/env/`
`vim ~/.config/plasma-workspace/env/ssh-askpass.sh`
`chmod +x ~/.config/plasma-workspace/env/ssh-askpass.sh`

```
#!/bin/sh

SSH_ASKPASS='/usr/bin/ksshaskpass'
export SSH_ASKPASS
```

## Step 5: Run ssh-add on Plasma start

`mkdir -p ~/config/autostart-scripts/`
`vim ~/config/autostart-scripts/ssh-add.sh`
`chmod +x ~/config/autostart-scripts/ssh-add.sh`

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
