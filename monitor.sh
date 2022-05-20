#! /bin/sh  
# supervisor process   
      
LOG_FILE=./monitor_sh.log  
      
# log function   
log() {  
    t=$(date +"%F %X")  
    echo "[ $t ] $0 : $1 " >> ${LOG_FILE}  
}   
# check process number   
# $1 : process name   
check_process() {  
	if [ -z $1 ]; then  
        	log "Input parameter is empty."  
        	return 0       
    	fi
    	p_num=$(ps -e | grep "$1" | grep -v "grep" | wc -l)  
	#log "p_num = $p_num"   
	echo $p_num  
}  
      
# supervisor process   
while [ 1 ]  
do   
    #1. check hived
    p_name="neoxad"
    ch_num=$(check_process $p_name)
    if [ $ch_num -eq 0 ]; then
        log "process neoxad is dead, restarting..."
        log "$(pwd)"
        hived
	sleep 1
    fi
    # 2. check node
    p_name="node"  
    ch_num=$(check_process $p_name)  
    if [ $ch_num -eq 0 ]; then 
	log "process node init.js is dead, restarting..." 
	log "$(pwd)"
	nohup node init.js &	
    fi
    sleep 3   
done  


