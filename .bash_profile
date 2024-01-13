# override cd to execute custom stuff when called
function cd() {
  builtin cd "$1"
  if [ -a ".nvmrc" ]; then
    nvm use
    if [ $? -eq 1 ]; then
      nvm install && nvm use
    fi
  fi
}

# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
  [ -r "$file" ] && source "$file"
done
unset file

# node version manager
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults
eval "$(rbenv init -)"
eval "$(direnv hook bash)"
cd ~/src
export PATH="/usr/local/opt/thrift@0.9/bin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/Users/david.mai/.local/bin:$PATH"
export PATH="/Users/david.mai/Library/Python/2.7/bin:$PATH"
export PATH="/Users/david.mai/Library/Python/2.7/bin:$PATH"
export PATH="/users/david.mai/miniconda/condabin:$PATH"
export MFA_DEVICE='arn:aws:iam::210246326331:mfa/david.mai'
export GOPATH=$HOME/src
eval "$(pyenv init -)"

[[ -s "/Users/david.mai/.gvm/scripts/gvm" ]] && source "/Users/david.mai/.gvm/scripts/gvm"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/david.mai/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/david.mai/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/david.mai/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/david.mai/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export VAGRANT_MEM=16384
export AWS_SDK_LOAD_CONFIG=true
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# Append to the history file, rather than overwriting it
shopt -s histappend

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"