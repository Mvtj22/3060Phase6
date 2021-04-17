# Pull the latest version of the project and prepare it for testing
echo "Create Fresh version of project"

export WORKING_DIR=$PWD
export PROJECT_DIR="Project"
export BACK_END="BackEnd"
if [ -d "$WORKING_DIR" ]; then rm -Rf $PROJECT_DIR; fi
if [ -d "$WORKING_DIR" ]; then rm -Rf $BACK_END; fi

git clone https://github.com/Mvtj22/3060FrontEnd.git "$PROJECT_DIR"
git clone https://github.com/jonathan-hermans/SQA "$BACK_END"

export BUILD="../$PROJECT_DIR/testFile/testFile/"
echo "Build Path: $BUILD"

# Get Lists of files to test against. 
cd "$WORKING_DIR/Inputs"
ITEMS=$(find . -type f -print)

# Change directory to our build to run our program. 
cd "$WORKING_DIR/Outputs"

# empty the current Ouputs
for i in */
do
	cd $i
	for j in *
	do
		rm $j
	done
	cd ..
done
rm newMasterCBA.info

Day=1;

for i in */
do
	arg1="$WORKING_DIR/Outputs/${i}WholeDay.etf"
	arg2=""
	arg3="$WORKING_DIR/Outputs/newMasterCBA.info"
	arg4="$WORKING_DIR/Outputs/${i}newCBAFile.info"

	if [[ $Day == 1 ]]
	then
		arg2="$WORKING_DIR/$BACK_END/MasterBankAccountsFile.txt"
	else
		arg2="$WORKING_DIR/Outputs/newMasterCBA.info"
	fi

	.././Phase6Daily.sh $Day "$arg1" "$arg2" "$arg3" "$arg4"

	Day=$(($Day+1))
done
