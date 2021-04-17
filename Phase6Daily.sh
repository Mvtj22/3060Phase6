# Pull the latest version of the project and prepare it for testing
echo "Create Fresh version of project"

export WORKING_DIR=$PWD
export PROJECT_DIR="Project"
export BACK_END="BackEnd"
#if [ -d "$WORKING_DIR" ]; then rm -Rf $PROJECT_DIR; fi
#if [ -d "$WORKING_DIR" ]; then rm -Rf $BACK_END; fi

#git clone https://github.com/Mvtj22/3060FrontEnd.git "$PROJECT_DIR"
#git clone https://github.com/jonathan-hermans/SQA "$BACK_END"

echo "Building Current Project"
cd "$WORKING_DIR/$PROJECT_DIR/testFile/testFile"
make 

export BUILD="../$PROJECT_DIR/testFile/testFile/"
echo "Build Path: $BUILD"


echo "Enter the day number (1, 2, 3, 4 or 5): "
read varname

# Get inputs. 
cd "$WORKING_DIR/Inputs/Day$varname"
ITEMS=$(find . -type f -print)

# Change directory to our build to run our program. 
cd ../$BUILD

# Iterate over our input files and run it. 
for i in $ITEMS
do 
	if [[ ${i: -4} == ".inp" ]]; then 
    	export INPUT_NAME=$(echo $i | sed -r "s/.+\/(.+)\..+/\1/")
    	echo "Executing Input: $INPUT_NAME"
    	cat "../../../Inputs/Day$varname/$i" |"./BankingSystem" > "../../../Outputs/Day$varname/$i.bto"
    	cp "./ioFiles/session.etf" "../../../Outputs/Day$varname/$i.etf"
  	fi
done

# Change to Output Directory and get files
cd "$WORKING_DIR/Outputs/Day$varname"
ITEMS=$(find . -type f -print)

rm "$WORKING_DIR/Outputs/Day$varname/WholeDay.etf"
max=$(ls -F | grep -v .bto | grep -v .info | wc -l)

cd ../$BUILD

# Iterate over our input files and merge them. 
count=1
for i in $ITEMS
do 
	if [[ ${i: -4} == ".etf" ]]; then 
    	export ETF_NAME=$(echo $i | sed -r "s/.+\/(.+)\..+/\1/")
    	echo "Merging ETF: $ETF_NAME"
		if [[ $count == $max ]]
		then
			cat "../../../Outputs/Day$varname/$i" >> "../../../Outputs/Day$varname/WholeDay.etf"
		else
			sed '$d' "../../../Outputs/Day$varname/$i" >> "../../../Outputs/Day$varname/WholeDay.etf"
		count=$(($count+1))
		echo $count $max
		fi
  	fi
done

cd "$WORKING_DIR/$BACK_END"

mergedBankTransFile="$WORKING_DIR/Outputs/Day$varname/WholeDay.etf"
temp="$WORKING_DIR/Outputs"

javac Writer.java Withdrawal.java Transfer.java Transaction.java Reader.java Paybill.java Disable.java Deposit.java ChangePlan.java BatchProcessor.java Accounts.java Account.java
java BatchProcessor "$mergedBankTransFile" "MasterBankAccountsFile.txt" "$temp/newMasterCBA.info" "$temp/Day$varname/newCBAFile.info"