function mkcd(){
	mkdir "$1"; cd "$1"
}

function up(){
	back="cd "
	if [ "$1" == "" ]; then
		back+="../"
	else
		for ((i=0; i < "$1"; i++)) do
			back+="../"	
		done
	fi
	eval "$back"
}
