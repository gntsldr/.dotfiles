# .dotfiles

## Starting from scratch

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:

```zsh
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
```

The first line creates a folder ~/.dotfiles which is a Git bare repository that will track our files.
Then we create an alias config which we will use instead of the regular git when we want to interact with our configuration repository.
We set a flag - local to the repository - to hide files we are not explicitly tracking yet. This is so that when you type config status and other commands later, files you are not interested in tracking will not show up as untracked.
Also you can add the alias definition by hand to your .zshrc or use the the fourth line provided for convenience.

## Install your dotfiles onto a new system (or migrate to this setup)

If you already store your configuration/dotfiles in a Git repository, on a new system you can migrate to this setup with the following steps:

Prior to the installation make sure you have committed the alias to your .bashrc or .zshrc:

```zsh
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:

```zsh
echo ".dotfiles" >> .gitignore
```

Now clone your dotfiles into a bare repository in a "dot" folder of your $HOME:

```zsh
git clone --bare https://github.com/gntsldr/.dotfiles.git $HOME/.dotfiles
```

Define the alias in the current shell scope:

```zsh
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Checkout the actual content from the bare repository to your $HOME:

```zsh
config checkout
```

The step above might fail with a message like:

```zsh
error: The following untracked working tree files would be overwritten by checkout:
    .zshrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

This is because your $HOME folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:

```zsh
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

Re-run the check out if you had problems:

```zsh
config checkout
```

Set the flag showUntrackedFiles to no on this specific (local) repository:

```zsh
config config --local status.showUntrackedFiles no
```

You're done, from now on you can now type config commands to add and update your dotfiles:

```zsh
config status
config add .vimrc
config commit -m "Add vimrc"
config add .zshrc
config commit -m "Add zshrc"
config push
```

Source: <https://www.atlassian.com/git/tutorials/dotfiles>
