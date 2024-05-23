# System

There are a collection of install scripts that I use to setup a new system. The
goal is to be able to run a single script and have a system ready to go. Of
course, there are somethings that can't be automated, but this should get you
90% of the way there.

## Usage

```shell
make
```

## Order of operations

1. Install Xcode CLI tools
2. Install brew
3. Install applications (through brew)
4. Install oh-my-zsh and Spaceship
5. Install applications (through Mac App Store)

## If you're customizing this

If you're customizing this for your own use, you'll want to change the
applications that are listed in the scripts:

- `applications.sh` - This is the list of applications that are installed
  through brew
- `mas_install.sh` - This is the list of applications that are installed through
  the Mac App Store
- `spaceship_install.sh` - This install oh-my-zsh and Spaceship

To remove one of the scripts, remove the line from the `Makefile` that
orchestrates the install.

## TODO

- [ ] Add a script to install all the fonts
