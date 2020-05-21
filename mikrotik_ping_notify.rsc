# ------------------- Header -------------------
# Ping IP addresses and notify via telegram bot
# Author: Emmanuel Nwankwo
# Email: emmanueln.nike@gmail.com
# Version: 1.0
#
# Follow the instructions in the link below to create your bot
# https://core.telegram.org/bots
# 
# Follow the instructions in the stack overflow URL below to get your chat ID
# https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id
# ------------------- Header -------------------

# Check IP Hosts(You can add more hosts if needed but remember to check firewall rules and whitelist them if you need )
:local PingTargets {"108.67.222.222";"9.8.8.8";"185.19.184.35"}

# Declare the global variables
:local PingFailCount

# This initializes the PingFailCount variables, in case this is the 1st time the script has ran
:if ([:typeof $PingFailCount] = "nothing") do={
	:set PingFailCount 0
}

# This variable will be used to keep results of individual ping attempts
:local PingResult

# Amount of ping fails needed to declare route as faulty
:local FailTreshold 3

# Amount of ping fails needed to declare route as faulty
:local url

# Telegram bot key
:local telegramBotKey "[Bot:API-key]"

# Telegram chat ID
:local telegramChatId "[Chat ID]"

###########################################################################################

:foreach k,pingTarget in=$PingTargets do={

	:delay 1s;

	:set PingResult [ping $pingTarget count=2];

 	# remote ping failed, increase fail count isp +1
	:if ($PingResult = 0) do={
		:set PingFailCount ($PingFailCount + 1)
		/log error "Ping to $pingTarget FAILED - no ping"
	};

	# remote ping passed
	#:if ($PingResult > 0) do={
	#	:if ($PingFailCount > 0) do={
	#		# Do something if the ping passes
	#	};
	#};
};

#if ping failures meets threshold send telegram notification through bot
:if ($PingFailCount >= $FailTreshold) do={
	:local url ("https://api.telegram.org/bot" . ($telegramBotKey) . "/sendMessage\?chat_id=" . ($telegramChatId) . "&text=" . ($PingFailCount) . "%20Ping%20failures%20exceeded%20threshold")
	/tool fetch url=$url keep-result=no
}