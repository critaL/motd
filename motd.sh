#!/bin/bash
export TERM=xterm-256color
CPUTIME=$(ps -eo pcpu | awk 'NR>1' | awk '{tot=tot+$1} END {print tot}')
CPUCORES=$(cat /proc/cpuinfo | grep -c processor)
IP=$(curl -s -4 icanhazip.com) > /dev/null
cpuTemp0="scale=1; $(cat /sys/class/thermal/thermal_zone0/temp)/1000"
curl -s wttr.in/falköping?lang=sv > /usr/local/bin/wttr
motdLastUpdate=$(ls -l /etc/motd | awk {'print $8'})

echo "$(tput sgr0)
$(tput smul)System Status$(tput rmul)
- IP Adresses       = $(tput dim)public:$(tput sgr0) `echo $IP`;	$(tput dim)private:$(tput sgr0)  `hostname -I`
- CPU Status        = $(tput dim)usage:$(tput sgr0) `echo $CPUTIME / $CPUCORES | bc`%;    $(tput dim)temp:$(tput sgr0) `echo $cpuTemp0 | bc`
- Disk Space Used   = $(tput dim)internal:$(tput sgr0) `df | head -n 2 | tail -n 1 | awk {'print $5'}`;
- Uptime            = $(tput dim)$(tput sgr0)`uptime | awk {'print $3,$4'} | cut -d ',' -f1`; Percent Up = $(tput dim)$(tput sgr0)`uprecords | tail -n 1 | awk {'print$2'} | cut -d '.' -f1`%;


$(tput smul)Service Status$(tput rmul)
- PiHole            = `ps -ef | grep -v grep | grep dnsmasq | wc -l | sed -e 's/1/working/g' -e's/0/inactive/g' | sed "s,working,$(tput setaf 2)&$(tput sgr0)," | sed "s,inactive,$(tput setaf 1)&$(tput sgr0),"`
- PiVPN             = `ps -ef | grep -v grep | grep openvpn | wc -l | sed -e 's/1/working/g' -e's/0/inactive/g' | sed "s,working,$(tput setaf 2)&$(tput sgr0)," | sed "s,inactive,$(tput setaf 1)&$(tput sgr0),"`

 `cat '/usr/local/bin/wttr' | head -n 7 | tail -n 5`

Updated $(tput smul)$motdLastUpdate$(tput rmul) 
" > /etc/motd


#
#- PiHole            = `pihole status | head -n 2 | tail -n 1 | sed -s 's/Enabled/working/g' | sed -s 's/Disabled/inactive/g' | grep -Eo 'working|inactive' | sed "s,working,$(tput setaf 2)&$(tput sgr0)," | sed "s,inactive,$(tput setaf 1)&$(tput sgr0),"`
