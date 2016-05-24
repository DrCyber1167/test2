  if [ $NONVOLUNTARY != $NONVOLUNTARYCHECK ] || [ $VOLUNTARY != $VOLUNTARYCHECK ]; then
    echo -e "$f5 BOT RUNNING!$rst"
    OK=$(( $OK + 1 ))

  else
    echo -e "$f5 BOT NOT RUNING, TRYING TO RELOAD IT...$rst"
    BAD=$(( $BAD + 1 ))
    sleep 1
    
    rm ../.telegram-cli/state 2>/dev/null

    kill $CLIPID
    kill $SCREEN
    
    screen -d -m bash launch.sh
    sleep 1
    
    CLIPID=ps -e | grep telegram-cli | sed 's/^[[:space:]]*//' | cut -f 1 -d" "
    
    if [ -z "${CLIPID}" ]; then
      echo -e "$f1 ERROR: TELEGRAM-CLI PROCESS NOT RUNNING$rst"
      echo -e "$f1 FAILED TO RECOVER BOT$rst"
      sleep 1
    fi
    
    SCREENNUM=ps -e | grep -c screen
    if [ $SCREENNUM != 3 ]; then
      echo -e "$f1 ERROR: SCREEN RUNNING: $SCREENNUM \n SCREEN ESPECTED: 3$rst"
      echo -e "$f1 FAILED TO RECOVER BOT$rst"
      exit 1
    fi

    SCREEN=ps -e | grep -v $SCREENPID1 | grep -v $SCREENPID2 | grep screen | sed 's/^[[:space:]]*//' | cut -f 1 -d" "
    echo -e "$f5 BOT HAS BEEN SUCCESFULLY RELOADED!$rst"
    echo -e "$f2 TELEGRAM-CLI NEW PID: $CLIPID$rst"
    echo -e "$f2 SCREEN NEW PID: $SCREEN$rst"
    sleep 3
    
  fi
  
  # Clear cache after 10h
  if [ "$OK" == 2400 ]; then
    sync
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
  fi
  
  VOLUNTARY=echo $VOLUNTARYCHECK
  NONVOLUNTARY=echo $NONVOLUNTARYCHECK
  sleep $RELOADTIME
  rm CHECK
  
  done

}

function tmux_detached {
clear
TMUX= tmux new-session -d -s script_detach "bash steady.sh -t"
echo -e "\e[1m"
echo -e ""
echo "Bot running in the backgroud with TMUX"
echo ""
echo -e "\e[0m"
sleep 3
tmux kill-session script 2>/dev/null
exit 1
}

function screen_detached {
clear
screen -d -m bash launch.sh
echo -e "\e[1m"
echo -e ""
echo "Bot running in the backgroud with SCREEN"
echo ""
echo -e "\e[0m"
sleep 3
quit
exit 1
}



if [ $# -eq 0 ]
then
  echo -e "\e[1m"
  echo -e ""
  echo "Missing options!"
  echo "Run: bash steady.sh -h  for help!"
  echo ""
  echo -e "\e[0m"
    sleep 1
  exit 1
fi

while getopts ":tsTSih" opt; do
  case $opt in
    t)
  echo -e "\e[1m"
  echo -e ""
  echo "TMUX multiplexer option has been triggered." >&2
  echo "Starting script..."
  sleep 1.5
  echo -e "\e[0m"
  tmux_mode
  exit 1
      ;;
  s)
  echo -e "\e[1m"
  echo -e ""
  echo "SCREEN multiplexer option has been triggered." >&2
  echo "Starting script..."
  sleep 1.5
  echo -e "\e[0m"
  screen_mode
  exit 1
      ;;
    T)
  echo -e "\e[1m"
  echo -e ""
  echo "TMUX multiplexer option has been triggered." >&2
  echo "Starting script..."
  sleep 1.5
  echo -e "\e[0m"
  tmux_detached
  exit 1
      ;;
  S)
  echo -e "\e[1m"
  echo -e ""
  echo "SCREEN multiplexer option has been triggered." >&2
  echo "Starting script..."
  sleep 1.5
  echo -e "\e[0m"
  screen_detached
  exit 1
      ;;
  i)
  echo -e "\e[1m"
  echo -e ""
  echo "steady.sh bash script v1.2 parsa alemi 2016 DBTeam" >&2
  echo ""
  echo -e "\e[0m"
echo -e "\033[38;5;208m _ __   __ _ _ __ ___  __ _      \033[0;00m"
echo -e "\033[38;5;208m| '_ \ / _` | '__/ __|/ _` |     \033[0;00m"
echo -e "\033[38;5;208m| |_) | (_| | |  \__ \ (_| |     \033[0;00m"
echo -e "\033[38;5;208m| .__/ \__,_|_|  |___/\__,_|     \033[0;00m"
echo -e "\033[38;5;208m|_|                              \033[0;00m"  
echo ""
  exit 1
      ;;
  h)
  echo -e "\e[1m"
  echo -e ""
  echo "Usage:"
  echo -e ""
  echo "steady.sh -t"
  echo "steady.sh -s"
  echo "steady.sh -T"
  echo "steady.sh -S"
  echo "steady.sh -h"
  echo "steady.sh -i"
    echo ""
  echo "Options:"
  echo ""
    echo "   -t     select TMUX terminal multiplexer"
  echo "   -s     select SCREEN terminal multiplexer"
  echo "   -T     select TMUX and detach session after start"
  echo "   -S     select SCREEN and detach session after start"
  echo "   -h     script options help page"
  echo "   -i     information about the script"
  echo -e "\e[0m"
  exit 1
  ;;
    
    \?)
  echo -e "\e[1m"
  echo -e ""
    echo "Invalid option: -$OPTARG" >&2
  echo "Run bash $0 -h for help"
  echo -e "\e[0m"
  exit 1
      ;;
    :)echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
