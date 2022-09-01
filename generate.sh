#!/bin/zsh


guilds=(
	'korriban 634874313'
	'mandalore 658989798'
	'scarif 986257863'
	'tatooine 826671465'
	'dagobah 827524916'
	'forestsofendor 924492956'
	'coruscant 879812164'
	'naboo 212765237'
	'mustafar 898889991'
	'ryloth 647855387'
	'kashyyyk 952238127'
	'mortis 522829215'
	'ilum 359151887'
	'alderaan 536478426'
	'bespin 551556315'
	'exegol 136663451'
	'lothal 675544966'
	'jedha 798573153'
	'ziost 821851365'
	'geonosis 478475664'
	'concorddawn 992228328'
)

# prime the pipe -- fetch the first guild
echo "==============="
echo "FETCH: $guilds[1]"
args=("${(@s/ /)guilds[1]}")

echo "~/bin/swgoh-tool --fetch $args[2] $args[1]"
time ~/bin/swgoh-tool --fetch $args[2] $args[1] || exit 1


for ((i = 1; i < $#guilds; i++)) ; do 
	args=("${(@s/ /)guilds[i]}")
	
	# now build the guild we just fetched
	echo "~/bin/swgoh-tool --brg --guild $args[1].json --site docs"
	time ~/bin/swgoh-tool --brg --guild $args[1].json --site docs &
	
	# and fetch the next one
	
	echo "==============="
	args=("${(@s/ /)guilds[i + 1]}")
	echo "FETCH: $args"

	echo "~/bin/swgoh-tool --fetch $args[2] $args[1]"
	time ~/bin/swgoh-tool --fetch $args[2] $args[1] || exit 1
	
	# wait for both to complete
	wait
	
done

# finish the pipeline
args=("${(@s/ /)guilds[$#guilds]}")
echo "~/bin/swgoh-tool --brg --guild $args[1].json --site docs"
time ~/bin/swgoh-tool --brg --guild $args[1].json --site docs &

echo "==============="
echo "ALLIANCE"

time ~/bin/swgoh-tool --brg --alliance docs *.json

wait

ret=$?; times; exit "$ret"
