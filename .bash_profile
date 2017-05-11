# Put custom stuff on top


# https://github.com/stefansundin/dotfiles/blob/master/.bash_profile
export PATH="$PATH:$HOME/bin:/usr/local/bin:/Applications/Firefox.app/Contents/MacOS:/Applications/Postgres.app/Contents/Versions/9.4/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims:node_modules/.bin:$HOME/Library/Android/sdk/platform-tools:$HOME/Library/Android/sdk/tools/templates/gradle/wrapper:$HOME/Library/Android/sdk/tools/proguard/bin:$HOME/Library/Android/sdk/tools"
export IGNOREEOF=5
export LESSHISTFILE=-
export TERM=xterm-256color
export PGHOST=localhost
export PGDATA="$HOME/Library/Application Support/Postgres/var-9.4"
#export PS0='Command started: \t\n'

# Mac
export HOMEBREW_NO_AUTO_UPDATE=1
alias flushdns='dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# Go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

function go-get {
  DIR=$(echo $1 | sed -e 's/.*@//' -e 's/:/\//' -e 's/\.git$//')
  NAME=$(basename $DIR)
  command git clone --recursive $1 $GOPATH/src/$DIR || return
  ln -s $GOPATH/src/$DIR $NAME
  cd $NAME
}

# SSH auth using gpg key
# echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf
# to restart:
# killall gpg-agent scdaemon shutdown-gpg-agent
# eval $(gpg-agent --daemon)
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=~/.gnupg/S.gpg-agent.ssh
gpgconf --launch gpg-agent

#export EDITOR='subl -w'
export EDITOR=vim
export VISUAL=vim
# Ubuntu:
# sudo update-alternatives --config editor
# Select vim.basic (which is normal vim)

# wget https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt
export SSL_CERT_FILE="$HOME/ca-bundle.crt"

# debchange
export DEBFULLNAME="Stefan Sundin"
export DEBEMAIL=stefan@example.com

# xterm-256color removes the color over ssh on some machines
alias ssh='TERM=xterm-color ssh'
alias gpg="gpg2"
alias ls="ls -G"
alias pc="pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB -brute"
alias reload_profile=". ~/.profile"
#alias npm-exec='PATH=$(npm bin):$PATH'

source /usr/local/etc/bash_completion
#complete -C /usr/local/bin/aws_completer aws
complete -C $HOME/Library/Python/2.7/bin/aws_completer aws

function aws {
  if [[ "$@" == *"--help"* ]]; then
    command aws "${@/--help/help}"
  else
    command aws "$@"
  fi
}

function travis-run {
  curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Travis-API-Version: 3" \
    -H "Authorization: token $(travis token --pro)" \
    -d "{\"request\":{\"branch\":\"${2:-master}\"}}" \
    "https://api.travis-ci.com/repo/$(echo $1 | sed 's/\//%2F/')/requests"
  open "https://travis-ci.com/$1/builds"
}

function postgresql {
  echo ${1//[\/@]/:} | awk -F: '{ printf "\"user=%s password=%s host=%s port=%d dbname=%s\"", $4, $5, $6, $7, $8 }'
}

function r {
  url=$1
  shift
  redis-cli $(echo "$url" | sed -E -e 's/redis:\/\/([^:]*)?:/-a /' -e 's/\@/ -h /' -e 's/:/ -p /' -e 's/\///g') "$@"
}

function dig {
  ARG=${*#http:\/\/}
  ARG=${*#https:\/\/}
  ARG=${ARG%%\/*}
  command dig $ARG
}

function nc {
  # nc -vz stage-test-app.abcdefghijkl.us-east-1.rds.amazonaws.com:5432
  if [[ "$@" == *":"* ]]; then
    command nc ${@/:/ }
  else
    command nc "$@"
  fi
}

function c {
  echo "$@" | pbcopy
  echo "Copied '$@' to clipboard!"
}

# pbcopy and pbpaste for Linux
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'


# Git

function git {
  if [[ "$1" == "clone" && "$@" != *"--help"* ]]; then
    shift 1
    command git cl "$@" || return

    if [[ "$@" == *"stefansundin/"* ]]; then
      for ((i=1; i<=$#; i++)); do
        if [[ ${!i} == "--bare" || ${!i} == "--mirror" ]]; then
          return
        elif [[ ${!i:0:1} != "-" ]]; then
          if [ -d "${!i}" ]; then
            DIR="${!i}"
          else
            REPO="${!i}"
            DIR=$(echo "${!i}" | sed -e 's/.*[\/|:]//' -e 's/\.git$//')
          fi
        fi
      done
      echo "Setting up additional git config..."
      builtin cd "$DIR"
      git config commit.gpgSign true
      git submodule foreach --recursive config commit.gpgSign true
      if [[ "$@" == *":stefansundin/"* ]]; then
        git remote add upstream "${REPO/stefansundin/upstream}"
      fi
      builtin cd - > /dev/null
    fi
  else
    command git "$@"
  fi
}

function git-root {
  GITROOT=`git rev-parse --show-toplevel 2> /dev/null`
  if [ "$GITROOT" == "" ]; then
    echo "You are not in a git repo."
    return 1
  fi
  cd "$GITROOT"
}

function cd {
  builtin cd "$@"
  echo -n -e "\033]0;$(git config --get remote.origin.url | sed -e 's/.*[\/|:]//' -e 's/\.git$//')\007";
}

function git_branch {
  git rev-parse --abbrev-ref HEAD 2> /dev/null | sed -e 's/\(.*\)/ \[\1\]/'
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local     DEFAULT="\[\033[0m\]"
  # PS1="$LIGHT_GREEN\h:\u:$RED\W$BLUE\$(git_branch) $DEFAULT\$ "
  PS1="$LIGHT_GREEN\u$DEFAULT:$RED\W$BLUE\$(git_branch) $DEFAULT\$ "
}
proml


# Ruby

eval "$(rbenv init -)"
# export RAILS_ENV=development
# export RACK_ENV=development

alias rsetup="RAILS_ENV=test bundle && RAILS_ENV=test bundle exec rake db:migrate"
alias rtest="RAILS_ENV=test bundle exec rspec"
alias resquework="bundle exec rake resque:work QUEUE=*"
alias log="tail -f -n2500 log/development.log"
alias schemadump="bundle exec rake db:schema:dump db:structure:dump"

# auto bundle exec
function use_bundler {
  if [ -r ./Gemfile ]; then
    bundle exec $@
  else
    $@
  fi
}

for cmd in rake rspec cucumber cap unicorn puma thin rackup guard compass thor sidekiq jekyll airbrake honeybadger; do
  alias $cmd="use_bundler $cmd"
done
