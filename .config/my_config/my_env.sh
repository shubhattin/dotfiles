yojanam() {
  if [[ $# -eq 0 ]]; then
    cd ~/yojanAni
  elif [[ $1 = 'nvim-config' ]]; then
    cd ~/.config/nvim
  elif [[ $1 = 'os-config' ]]; then
    cd ~/.config/os-config
  elif [[ $1 = 'chala' ]]; then
    cd /mnt/c/Users/shubh/.chalachitrani
  elif [[ $1 = 'downloads' ]]; then
    cd /mnt/c/Users/shubh/Downloads
  elif [[ $1 = 'videos' ]]; then
    cd /mnt/c/Users/shubh/Videos
  elif [[ -d "$HOME/yojanAni/$1" ]]; then
    cd "$HOME/yojanAni/$1"
  else
    echo "$1 :- Not Found"
  fi
}
