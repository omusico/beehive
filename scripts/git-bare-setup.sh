#!/bin/sh

if [[ -z $1 ]]; then
  echo "You must pass the name of the git repos when using this script";
  echo ""
  echo "Usage: "
  echo " $0 <nameofrepos> <run?>"
  echo ""
  exit 1;
fi
APP_NAME=$1
RUN=$2
cd `dirname $APP_NAME`

echo "mkdir $APP_NAME"
if [[ -z $RUN ]]; then
  mkdir $APP_NAME
fi

echo "cd $APP_NAME && git --bare init"
if [[ -z $RUN ]]; then
  cd $APP_NAME && git --bare init
fi

echo "Making post-commit hook"
if [[ -z $RUN ]]; then  
  STR="
    #!/bin/sh
    
    Post commit hook
  "
  
   echo $STR > $APP_NAME/hooks/post-commit
fi