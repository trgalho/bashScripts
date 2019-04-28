#
# Generate a .ts file from a .json file.
#
#
# Talisson Galho
#

RED_COLOR='\u001b[31m';
RESET_COLOR='\u001b[0m';
BRIGHT_GREEN_COLOR='\u001b[32;1m';
BRIGHT_YELLOW_COLOR='\u001b[33;1m';
BRIGHT_RED_COLOR='\u001b[31;1m';

echo "################################################################"
echo "#                                                              #"
echo "#            Generate a .ts file from a .json file.            #"
echo "#                                                              #"
echo "################################################################"
echo "";

if [ "$1" == "" ] || [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "-h" ]; then
    echo " json-to-ts.sh only accept a .json file as argument.";
    echo "";
    echo -e "$BRIGHT_GREEN_COLOR EXAMPLE:$RESET_COLOR";
    echo -e "    json-to-ts.sh $BRIGHT_YELLOW_COLOR/my/path/to/json/file.json$RESET_COLOR";
    echo "";    
    return;
fi

echo -e " Input file: $BRIGHT_GREEN_COLOR $1 $RESET_COLOR";
echo "";

if [ ! -e $1 ]; then
    echo " Input file not exists.";
    return;
fi

if [ ! -s $1 ]; then
    echo " Input file is empty.";
    return;
fi

if [ $(echo "$1" | grep -i '.json$' | wc -l ) \< 1 ]; then
    echo " Input file with invalid extension.";
    return;
fi


fileName=$(basename $1 | sed s/.json$//ig);

filePath=$(dirname $1);

if [ -e $filePath/$fileName.ts ]; then
    echo "";
    echo -e "$BRIGHT_YELLOW_COLOR The file $filePath/$fileName.ts already exists. $RESET_COLOR";
    echo -n " Do you want override this file? (y/N) ";
    read answer;
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ] || [ "$answer" == "s" ] || [ "$answer" == "S" ] ; then
        echo "";
        echo -e "$BRIGHT_RED_COLOR The file will be overrided. $RESET_COLOR";
    else
        while [ "$newFileName" == "" ]; do
            echo "";            
            echo " Please, insert a new filename: ";
            echo -n " ";        
            read newFileName; 
            if [ "$newFileName" == "" ];then 
                echo -e "$BRIGHT_RED_COLOR The filename name cant be a empty string. $RESET_COLOR";
            else
                fileName=$newFileName;
            fi
        done
    fi
    echo "";
fi
tsFileContent=$(echo -n "export default " $(cat $1 | sed 's/\"\(.*\)\":/\1:/ig'));

echo $tsFileContent > $filePath/$fileName.ts;

if [ "$(echo $tsFileContent)" == "$(cat $filePath/$fileName.ts)" ]; then
    echo -e "$BRIGHT_GREEN_COLOR The file $filePath/$fileName.ts was generated successfully. $RESET_COLOR"
else
    echo -e "$BRIGHT_RED_COLOR The content of file $filePath/$fileName.ts was not as expected. $RESET_COLOR"
fi
echo "";
