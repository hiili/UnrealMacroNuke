#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <UE version>, e.g. '4.17'>"
	exit 1
fi

ueversion=$1
uepath=/c/Program\ Files/Epic\ Games/UE_$ueversion/Engine/Source/Runtime

echo Scanning $uepath/*
pushd >/dev/null "$uepath" || exit 1
grep '^[[:space:]]*#define' -r --include='*.h' * | sed 's/.*#define[[:space:]]*\([a-zA-Z0-9_]*\)\(.*\)/\1/' | sort | uniq | cat > ~1/Macros_UE_${ueversion}.txt
echo "Missed macros due to empty first line:"
grep '^[[:space:]]*#define[[:space:]]*\\' -r --include='*.h' *
echo
popd >/dev/null

echo Generating UndefineMacros_UE_$ueversion.h and RedefineMacros_UE_$ueversion.h
cat < Macros_UE_${ueversion}.txt | grep -v '^_' | awk > UndefineMacros_UE_$ueversion.h '// { print "#pragma push_macro(\"" $1 "\")"; print "#undef " $1; }'
tac < Macros_UE_${ueversion}.txt | grep -v '^_' | awk > RedefineMacros_UE_$ueversion.h '// { print "#pragma pop_macro(\"" $1 "\")"; }'
