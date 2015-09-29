source $HOME/.antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle pip
antigen bundle command-not-found
antigen bundle autojump
antigen bundle common-aliases
antigen bundle aws
antigen bundle atom
antigen bundle docker
antigen bundle node
antigen bundle npm
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh

# OS X  packages
if [[ $(uname) == 'Darwin' ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle osx
fi

# Apply the pure theme
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

# Apply the packages and themes
antigen apply

## Path
GOPATH=$HOME/Developer/sandbox/gocode
GOROOT=/usr/local/opt/go/libexec/bin
ANDROID_PATH="/usr/local/Cellar/android-platform-tools/22.0.0/bin/:/Users/ryan/bin:/Users/ryan/Library/Android/sdk/build-tools/22.0.1/"
export PATH=$GOROOT:$GOPATH:"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin:/Users/ryan/bin":$ANDROID_PATH

## Functions
# Make a directory and cd into it
mkcd() {
    mkdir -p "$@"
    cd "$_";
}

# Build a docker image and run it locally
dockerRunlocal() {
    docker build -t $@ .
    docker run -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY  --publish 80:8080 --name test --rm $@
}

## Aliases
# Remove all untagged docker images
diclean='docker rmi $(docker images | grep "^<none>" | awk "{print $3}")'
# Remove all stopped docker containers
dcclean='docker rm $(docker ps -a -q)'

## Miscellaenous
# Load AWS credentials
if [[ -e $HOME/.aws/exportCredentials.sh ]]; then
    source $HOME/.aws/exportCredentials.sh
else
    echo "WARNING: No AWS credentials found."
fi
