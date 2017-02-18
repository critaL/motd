#!/bin/bash
export TERM=xterm-256color
CPUTIME=$(ps -eo pcpu | awk 'NR>1' | awk '{tot=tot+$1} END {print tot}')
CPUCORES=$(cat /proc/cpuinfo | grep -c processor)
IP=$(curl -s -4 icanhazip.com) > /dev/null
cpuTemp0="scale=1; $(cat /sys/class/thermal/thermal_zone0/temp)/1000"
curl -s wttr.in/$IP?lang=sv > /usr/local/bin/wttr
motdLastUpdate=$(ls -l /etc/motd | awk {'print $8'})

echo "$(tput sgr0)
$(tput smul)System Status$(tput rmul)
- IP Adresses       = $(tput dim)public:$(tput sgr0) `echo $IP`;        $(tput dim)private:$(tput sgr0)  `hostname -I`
- CPU Status        = $(tput dim)usage:$(tput sgr0) `echo $CPUTIME / $CPUCORES | bc`%;    $(tput dim)temp:$(tput sgr0) `echo $cpuTemp0 | bc`
- Disk Space Used   = $(tput dim)internal:$(tput sgr0) `df | head -n 4 | tail -n 1 | awk {'print $5'}`;
- Uptime            = $(tput dim)$(tput sgr0)`uptime | awk {'print $3,$4'} | cut -d ',' -f1`;

$(tput smul)Service Status$(tput rmul)
- Webserver       = `if [[ $(systemctl status nginx | grep -c "active (running)") -gt 0 ]]; then echo "$(tput setaf 2)Running$(tput sgr0)"; else python3 /home/noordan/service_check/service_check.py nginx; echo "$(tput setaf 1)Inactive$(tput sgr0)"; fi`
- MysQL           = `if [[ $(systemctl status mysql | grep -c "active (running)") -gt 0 ]]; then echo "$(tput setaf 2)Running$(tput sgr0)"; else python3 /home/noordan/service_check/service_check.py mysql; echo "$(tput setaf 1)Inactive$(tput sgr0)"; fi`
- PHP             = `if [[ $(systemctl status php7.0-fpm.service | grep -c "active (running)") -gt 0 ]]; then echo "$(tput setaf 2)Running$(tput sgr0)"; else python3 /home/noordan/service_check/service_check.py php7.0-fpm.service; echo "$(tput setaf 1)Inactive$(tput sgr0)"; fi`

 `cat '/usr/local/bin/wttr' | head -n 7 | tail -n 5`
Updated $(tput smul)$motdLastUpdate$(tput rmul)
" > /etc/motd


#- PiHole            = `pihole status | head -n 2 | tail -n 1 | sed -s 's/Enabled/working/g' | sed -s 's/Disabled/inactive/g' | grep -Eo 'working|inactive' | sed "s,working,$(tput setaf 2)&$(tput sgr0)," | sed "s,inactive,$(tput setaf 1)&$(tput sgr0),"`
