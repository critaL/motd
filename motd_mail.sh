#!/bin/bash
export TERM=xterm-256color
CPUTIME=$(ps -eo pcpu | awk 'NR>1' | awk '{tot=tot+$1} END {print tot}')
CPUCORES=$(cat /proc/cpuinfo | grep -c processor)
IP=$(curl -s -4 icanhazip.com) > /dev/null
#cpuTemp0="scale=1; $(cat /sys/class/thermal/thermal_zone0/temp)/1000"
curl -s wttr.in/$IP?lang=sv > /usr/local/bin/wttr
motdLastUpdate=$(date)


declare -A SERVICES=(
  ['Webserver']='nginx'
  ['PHP']='php7.0-fpm.service'
  ['fail2ban']='fail2ban.service'
  ['MySQL']='mysql'
  ['UFW']='ufw'
)

#service_check can be found here: https://github.com/noordan/service_check.git
echo "$(tput sgr0)
$(tput smul)System Status$(tput rmul)
- IP Adresses       = $(tput dim)public:$(tput sgr0) `echo $IP`;        $(tput dim)private:$(tput sgr0)  `hostname -I`
- CPU Status        = $(tput dim)usage:$(tput sgr0) `echo $CPUTIME / $CPUCORES | bc`%;    $(tput dim)temp:$(tput sgr0) `echo $cpuTemp0 | bc`
- Disk Space Used   = $(tput dim)internal:$(tput sgr0) `df | head -n 4 | tail -n 1 | awk {'print $5'}`;
- Uptime            = $(tput dim)$(tput sgr0)`uptime | awk {'print $3,$4'} | cut -d ',' -f1`;

`echo -e "\e[4mService status\e[0m"
for SERVICE in ${!SERVICES[@]}
do
  STATUS=$(sudo systemctl status ${SERVICES[$SERVICE]} --no-pager | grep -c "Active: active (running)")
  if [[ $STATUS > 0 ]]
  then
    STATUSTABLE+=(" - $SERVICE $(echo -en "= \e[32m")Running$(echo -en "\e[0m")\n")
  else
    STATUSTABLE+=(" - $SERVICE $(echo -en "= \e[31m")Dead$(echo -en "\e[0m")\n")
  fi
done
printf "${STATUSTABLE[*]}" | column -t`

 `cat '/usr/local/bin/wttr' | head -n 7 | tail -n 5`
Updated $(tput smul)$motdLastUpdate$(tput rmul)" > /etc/motd


#- PiHole            = `pihole status | head -n 2 | tail -n 1 | sed -s 's/Enabled/working/g' | sed -s 's/Disabled/inactive/g' | grep -Eo 'working|inactive' | sed "s,working,$(tput setaf 2)&$(tput sgr0)," | sed "s,inactive,$(tput setaf 1)&$(tput sgr0),"`
