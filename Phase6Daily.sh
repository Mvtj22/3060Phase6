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

# Get Lists of files to test against. 
cd "$WORKING_DIR/Inputs"
ITEMS=$(find . -type f -print)

# Change directory to our build to run our program. 
cd $BUILD

# Iterate over our input files and run it. 
for i in $ITEMS
do
  if [[ ${i: -4} == ".inp" ]]; then 
    export INPUT_NAME=$(echo $i | sed -r "s/.+\/(.+)\..+/\1/")
    echo "Executing Input: $INPUT_NAME"
    cat "../../../Inputs/$i" |"./BankingSystem" > "../../../Outputs/$i.bto"
    cp "./ioFiles/session.etf" "../../../Outputs/"
  fi
done