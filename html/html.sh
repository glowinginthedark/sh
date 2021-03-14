#!/bin/bash

PROJECTS_DIR=''
CURRENT_DIR=$(pwd)
HELPTEXT=$(cat <<-END
usage: html command [arguments]

Commands: -

ls\t\tLists existing projects.\n
new <item_name>\tCreates a new project with a default index.html in PROJECTS_DIR.
\t\t(PROJECTS_DIR => ${PROJECTS_DIR})\n
rm <item_name>\tDeletes a project.\n
END
)


d=()
items=() 

refresh_and_load_items () {
	items=()
	if [ -f "$CURRENT_DIR/items" ]; then
		n=$(wc -l "$CURRENT_DIR/items" | awk '{print $1}')
		for i in $(seq 1 $n);
		do
			line=$(sed "${i}q;d" "$CURRENT_DIR/items")
			if [ ! -d "$line" ]; then
				d+=($i)
			fi
		done
		for i in "${!d[@]}"
		do
			sed -i "$((d[$i] - i))d" "$CURRENT_DIR/items"
		done
		n=$(wc -l "$CURRENT_DIR/items" | awk '{print $1}')
		for i in $(seq 1 $n);
		do
			line=$(sed "${i}q;d" "$CURRENT_DIR/items")
			fn="${line##*/}"
			items+=("$fn")
		done
	fi
}

print_items () {
	echo ""
	echo -e " Item\tLast Modified" | awk -F "\t" '{printf "%-23s %-0s\n", $1, $2}'
	echo -e " ------------------------------------"
	for i in "${!items[@]}"
	do
		echo -e " ${items[$i]}  $(ls -asld $PROJECTS_DIR/${items[$i]} | awk '{print $7, $8, $9}')" | awk '{ printf " %-23s %-0s %-0s %-0s\n", $1, $2, $3, $4}'
	done
	echo ""
}

# check for --help
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo -e "$HELPTEXT"
        exit 0
fi

# check if PROJECTS_DIR exists
if [ ! -d "$PROJECTS_DIR" ]; then
	if [ "$PROJECTS_DIR" == "" ]; then
		echo "Hello :)"
		echo "If this is your first time using this script. Please specify a projects directory (where you want your HTML projects to live) on line #3 of this script. After that, you can run it again."
	else
		echo "Directory $PROJECTS_DIR does not exist. Please specify a projects directory that exists."
	fi
	echo "Exitting..."
	exit 1
fi

refresh_and_load_items

# check for args
if [ ! "$#" -ge 1 ]; then
        echo "No arguments provided. Exiting..."
        echo "Please use --help to view usage info."
        exit 0
fi

if [ "$1" == "ls" ]; then
	print_items
fi

if [ "$1" == "new" ]; then

	if [ ! "$#" -eq 2 ]; then
		echo "Please specify an item name: $ html new <name>"
		echo "Exitting..."
		exit 1
	fi

	current_project_dirpath=$PROJECTS_DIR/$2

	echo "$current_project_dirpath"

	if [ -d "$current_project_dirpath" ]; then
		echo "An item $2 already exists."
		echo "Please try a different name."
		exit 1
	else
		mkdir $current_project_dirpath
		
		cp $CURRENT_DIR/template $current_project_dirpath/index.html

		sleep 1

		echo ""
		cat $CURRENT_DIR/art.txt
		echo ""
		echo "Happy coding :)"
		echo ""
		
		sleep 1
		
		code $current_project_dirpath
		xdg-open $current_project_dirpath/index.html
		gnome-terminal --working-directory=$current_project_dirpath
		
		echo $current_project_dirpath >> $CURRENT_DIR/items
	fi
fi

if [ "$1" == "rm" ]; then

	if [ ! "$#" -eq 2 ]; then
		echo "Please specify an item name: $ html rm <name>"
		echo "exiting..."
		exit 1
	fi

	if printf '%s\n' "${items[@]}" | grep -q -P "^$2$"; then
		echo "Removing item '$2'..."
		sleep 0.5
		rm -r $PROJECTS_DIR/$2
		refresh_and_load_items
		echo "Removed."
		sleep 0.5
		echo ""
		echo "Remaining items: -"
		print_items
	fi

fi

if [ "$1" == "open" ]; then
	if [ ! "$#" -eq 2 ]; then
		echo "Please specify an item name: $ html open <name>"
		echo "Exiting..."
		exit 1
	fi

	if printf '%s\n' "${items[@]}" | grep -q -P "^$2$"; then
		gnome-terminal --working-directory=$PROJECTS_DIR/$2
	else
		echo "Item $2 doesn't exist."
		echo "Exiting..."
		exit 1
	fi

fi
