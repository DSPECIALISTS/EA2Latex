#!/bin/bash


function print_usage
{
cat <<EOF
        Usage: $(basename $0) {args}

        Creates a versioned copy of a EA2latex generated document

        Arguments:
		document filename
		version
		username for svn login (commit versioned document)
		password for svn login (commit versioned document)
                

EOF
}

function fail
{
	echo $1
	echo fail
	exit $2
}

NUM_MANDATORY_ARGS=4

if [ $# -ne $NUM_MANDATORY_ARGS ]
then
	echo "Not enough arguments ($#)."
	print_usage
	echo "fail"
	exit 1
fi
document=$1
doc_basename=`basename $document .pdf`
version=$2
username=$3
password=$4
document_config="document_config.tex"

1>&2

#replacing with new version
echo ""
echo "Adapting version-info and document path on title page to new version ($version) (in file $document_config)"
sed -i "s/eatexDocVer}{.*/eatexDocVer}{$version}/" $document_config
sed -i "/\\newcommand{\\eatexDocPath/s/.pdf/_$version.pdf/" $document_config

#rebuild PDF
echo ""
echo "Rebuild pdf document with new version info"
$(dirname $0)/default_build.sh -p -o ../$document

if [ $? -ne 0 ]
then
	fail "failed to generate document  ../$document" 10
fi


#copy sources and pdf and commit if version controlled
echo ""
echo "Copying sources and PDF document (use svn cp if version controlled)"

svn info
if [ $? -eq 0 ]
then
	#echo "svn cp ../$document ../${doc_basename}_${version}.pdf"
	svn cp ../$document ../${doc_basename}_${version}.pdf
	if [ $? -ne 0 ]
	then
        	fail "svn copy failed for ../$document" 11
	fi

	#echo "svn cp -r ../${doc_basename}-Source ../${doc_basename}_${version}-Source"
        svn cp ../${doc_basename}-Source ../${doc_basename}_${version}-Source
        if [ $? -ne 0 ]
        then
                fail "svn copy failed for ../${doc_basename}-Source" 12
        fi
	svn commit ../${doc_basename}_${version}.pdf ../${doc_basename}_${version}-Source -m "Adding new Version ($version) of Document $document to SVN" --username $username --password $password
        if [ $? -ne 0 ]
        then
                fail "svn commit failed" 13
        fi
else
	#echo "cp ../$document ../${doc_basename}_${version}.pdf"
	cp ../$document ../${doc_basename}_${version}.pdf
	#echo "cp -r ../${doc_basename}-Source ../${doc_basename}_${version}-Source"
	cp -r ../${doc_basename}-Source ../${doc_basename}_${version}-Source
fi

if [ $? -ne 0 ]
then
	fail "make_version failed" 1
fi

echo "version $version of document $document has successfully been created"
exit 0
