# ------------------- Header -------------------
# Ping IP addresses and notify via telegram bot
# Author: Emmanuel Nwankwo
# Email: emmanueln.nike@gmail.com
# Version: 1.0
#
# ------------------- Header -------------------

# Check IP Hosts(You can add more hosts if needed but remember to check firewall rules and whitelist them if you need )
:local PingTargets {"208.67.222.222";"8.8.8.8";"185.19.184.35"}

# Declare the global variables
:global PingFailCount

# This initializes the PingFailCount variables, in case this is the 1st time the script has ran
:if ([:typeof $PingFailCount] = "nothing") do={
	:set PingFailCount 0
}

# This variable will be used to keep results of individual ping attempts
:local PingResult

# Amount of ping fails needed to declare route as faulty
:local FailTreshold 3

###########################################################################################

:foreach k,pingTarget in=$PingTargets do={

	:delay 1s;

	:set PingResult [ping $pingTarget count=2];

 	# remote ping failed, increase fail count isp +1
	:if ($PingResult = 0) do={
		:set PingFailCount ($PingFailCount + 1)
		/log error "Ping to $pingTarget FAILED - no ping"
	};

	# remote ping passed, decrease fail count isp -1
	#:if ($PingResult > 0) do={
	#	:if ($PingFailCount > 0) do={
	#		:set PingFailCount ($PingFailCount - 1)
	#	};
	#};
};

#if ping failures meets threshold send telegram notification through bot
:if ($PingFailCountISP1 >= $FailTreshold) do={

	/tool fetch url="https://api.telegram.org/bot1051001146:AAHbbMlMch_l2VKqmhL6nnjmbwcrixLc7ek/sendMessage\?chat_id=-259483493&text=[Device.Name],%20@IP:%20[Device.FirstAddress]%20ping%20threshold%20failed)" keep-result=no
}