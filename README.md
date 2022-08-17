This project set up a newly bought device ready to be used for all my development work. This will configure
* some key bindings
* vim
* tmux
* shell
* git

# Ubuntu

The following provisions the current user and then install a cron to keep the settings up to date
```
sh -c "$(wget -O- https://raw.githubusercontent.com/laurent-xu/bootstrap/main/bootstrap.sh)"
```

If setting up a VPS you should first run
```
useradd l
passwd l
su l
```


# Useful shortcuts

## Global
```
Open terminal command+alt+T
Open browser command+alt+w
```

## vim
```
:G blame
:StripWhitespace
comma+t to fuzzy search a file
```
