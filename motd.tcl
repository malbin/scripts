#!/usr/bin/env tclsh
# MOTD script original? / mod mewbies.com

# * Variables
set var(user) $env(USER)
set var(path) $env(PWD)
set var(home) $env(HOME)

# * Check if we're somewhere in /home
#if {![string match -nocase "/home*" $var(path)]} {
if {![string match -nocase "/home*" $var(path)] && ![string match -nocase "/usr/home*" $var(path)] } {
  return 0
}

# * Calculate last login
set lastlog [exec -- lastlog -u $var(user)]
set ll(1)  [lindex $lastlog 7]
set ll(2)  [lindex $lastlog 8]
set ll(3)  [lindex $lastlog 9]
set ll(4)  [lindex $lastlog 10]
set ll(5)  [lindex $lastlog 6]

# * Calculate current system uptime
set uptime    [exec -- /usr/bin/cut -d. -f1 /proc/uptime]
set up(days)  [expr {$uptime/60/60/24}]
set up(hours) [expr {$uptime/60/60%24}]
set up(mins)  [expr {$uptime/60%60}]
set up(secs)  [expr {$uptime%60}]

# * Calculate usage of home directory
set usage [lindex [exec -- /usr/bin/du -ms $var(home)] 0]

# * Calculate SSH logins:
set logins     [exec -- w -s]
set log(c)  [lindex $logins 5]

# * Calculate processes
set psu [lindex [exec -- ps U $var(user) h | wc -l] 0]
set psa [lindex [exec -- ps -A h | wc -l] 0]

# * Calculate current system load
set loadavg     [exec -- /bin/cat /proc/loadavg]
set sysload(1)  [lindex $loadavg 0]
set sysload(5)  [lindex $loadavg 1]
set sysload(15) [lindex $loadavg 2]

# * Calculate Memory
set memory  [exec -- free -m]
set mem(t)  [lindex $memory 7]
set mem(u)  [lindex $memory 8]
set mem(f)  [lindex $memory 9]
set mem(c)  [lindex $memory 16]
set mem(s)  [lindex $memory 19]

# * Calculate disk temperature from hddtemp
#set sd(a) [lindex [exec -- /usr/bin/hddtemp /dev/sda -uc | cut -c "28-35"] 0]
#set sd(b) [lindex [exec -- /usr/bin/hddtemp /dev/sdb -uc | cut -c "28-35"] 0]
#set sd(c) [lindex [exec -- /usr/bin/hddtemp /dev/sdc -uc | cut -c "28-35"] 0]
#set sd(d) [lindex [exec -- /usr/bin/hddtemp /dev/sdd -uc | cut -c "28-35"] 0]
#set sd(e) [lindex [exec -- /usr/bin/hddtemp /dev/sde -uc | cut -c "28-35"] 0]
#set sd(f) [lindex [exec -- /usr/bin/hddtemp /dev/sdf -uc | cut -c "28-35"] 0]
#set sd(g) [lindex [exec -- /usr/bin/hddtemp /dev/sdg -uc | cut -c "28-35"] 0]
#set sd(h) [lindex [exec -- /usr/bin/hddtemp /dev/sdh -uc | cut -c "28-35"] 0]
#set sd(i) [lindex [exec -- /usr/bin/hddtemp /dev/sdi -uc | cut -c "28-35"] 0]
#set sd(j) [lindex [exec -- /usr/bin/hddtemp /dev/sdj -uc | cut -c "28-35"] 0]

# * Calculate temperature from lm-sensors
#set temperature    [exec -- sensors | grep temp]
#set tem(m)  [lindex $temperature 5]
#set tem(c)  [lindex $temperature 16]

#set coretemp    [exec -- sensors | grep Core]
#set core(0)  [lindex $coretemp 2]
#set core(1)  [lindex $coretemp 11]
#set core(2)  [lindex $coretemp 20]
#set core(3)  [lindex $coretemp 29]

# * Display weather
#set weather     [exec -- /usr/share/./weather.sh]
#set wthr(t)  [lindex $weather 0]
#set wthr(d)  [lindex $weather 1]
#set wthr(e)  [lindex $weather 2]

# * ascii head
set head {
                                  
                        .         
            o           |         
 .-. .--.   .  .--..  . |.-. .  . 
(   )|  |   |  `--.|  | |-.' |  | 
 `-' '  `--' `-`--'`--`-'  `-`--`-
                                                            
}

# * Print Results
puts $head
puts "  Last Login....: $ll(1) $ll(2) $ll(3) $ll(4) from $ll(5)"
puts "  Uptime........: $up(days)days $up(hours)hours $up(mins)minutes $up(secs)seconds"
puts "  Load..........: $sysload(1) (1minute) $sysload(5) (5minutes) $sysload(15) (15minutes)"
puts "  SSH Logins....: There are currently $log(c) users logged in."
puts "  Processes.....: You're running ${psu} which makes a total of ${psa} running"
puts "  Memory .......: Total: $mem(t)MB. Used: $mem(u)MB.  Free: $mem(f)MB.  Free Cached: $mem(c)MB.  Swap In Use: $mem(s)MB."
puts "  Disk Usage....: You're using ${usage}MB in $var(home)"
#puts "  Temperatures:"
#puts "  Core Temps ...: Core0: $core(0) Core1: $core(1) Core2: $core(2) Core3: $core(3)"
#puts "  Mobo Temps ...: M/B: $tem(m)  CPU: $tem(c)"
#puts "  Disk Temps ...: sda: $sd(a) sdb: $sd(b) sdc: $sd(c) sdd: $sd(d) sde: $sd(e)"
#puts "  Disk Temps ...: sdf: $sd(f) sdg: $sd(g) sdh: $sd(h) sdi: $sd(i) sdj: $sd(j)"
#puts "  Weather.......: $wthr(t) $wthr(d) $wthr(e)\n"

if {[file exists /etc/changelog]&&[file readable /etc/changelog]} {
  puts " . .. More or less important system informations:\n"
  set fp [open /etc/changelog]
  while {-1!=[gets $fp line]} {
    puts "  ..) $line"
  }
  close $fp
  puts ""
}

