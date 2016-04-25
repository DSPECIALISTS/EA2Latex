#!/bin/bash
# if option -onlypdf  is set, only tex to pdf conversion is done
# 1. crops pdfs with pdfcrop
# 2. builds pdf with pdflatex

onlypdflatex=0
verbose_out=0
target_doc=

umask 0007

rm -f eachapters.aux out.* #>/dev/null 2>&1
#chmod -R g+rw * #>/dev/null 2>&1

function print_usage
{
cat <<EOF
        Usage: $(basename $0) <[options]>

	Build document from templates at the location of this build script and
        eachapters.tex located in the current working directory. The document
        will be created as out.pdf and be copied to the target path if the -o
        option as been specified.

        Options:
                -h   Show this message
                -l   Select language {english|german} (default is german)
                -n   Document name (e.g. "HARVEY mx.16 Requirements")
                -t   Document type (e.g. "System Requirements Specification")
                -o   path to copy final document file to
                -p   PDF creation only (skip cropping of images, etc.)
                -v   Enable verbose output (e.g. pdflatex output)

EOF
}

function fail
{
	echo $1
	echo fail
	exit 1
}

# check options
while getopts ":o:l:n:t:phv" Option
do
	case $Option in
		h )
			print_usage
			exit 1
		;;
                l ) language="$OPTARG" ;;
		n ) doctitle="$OPTARG" ;;
		o ) target_doc="$OPTARG" ;;
		p ) onlypdflatex=1 ;;
		t ) doctype="$OPTARG" ;;
		v ) verbose_out=1 ;;
		* )
			fail "Option $OPTARG not recognized. Try -h for help."
		;;
	esac
done

# prepare file descriptors 5 and 6 for verbose output
if [ $verbose_out -eq 1 ]; then
exec 5<&1
exec 6<&2
else
exec 5<>/dev/null
exec 6<>/dev/null
fi



if [ $onlypdflatex -eq 0 ]; then
	# Cropping the pdf images
	for f in `ls eaimages/*.pdf`
	do
		pdfcrop "$f" "$f"
	done

	# converting rtf (linked documents) to tex
	for rtffile in *.rtf
	do	
		# rtf2latex2e hat offenbar einen Bug, so dass das erste Zeichen am
		# Anfang einer Tabellenzelle nicht formatiert wird, wenn es Fett oder
		# Kursiv sein sollte. Das Einfügen eines zusätzlichen Leerzeichens
		# nach dem Format-Befehl im RTF hilft da.
		# Das Folgende sed-Kommando sucht also das erste Vorkommen eines
		# einzelnen Leerzeichens in einer Zeile hinter einem \b oder \i 
		# Formatbefehl und verdoppelt es.
		sed -i 's/^\([^ ]*\)\\\([bi]\) \([^ ]\)/\1\\\2  \3/g' "$rtffile"
		rtf2latex2e -f -P /usr/local/share/rtf2latex2e/ -n "$rtffile"
		# remove trailing newline from file
		sed -i '$d' "${rtffile/%.rtf/.tex}"
	done
	
	chmod 774 eaimages/*.pdf
fi

template_path=$(dirname $0)

read langfromfile < "language.tex"
if [ -z "$langfromfile" ]; then
     langfromfile="deutsch"
     echo "read language $langfromfile from language file."
fi


if [ "$language" = "english" ]; then
	docfile="default_index_en.tex"
	echo "using language $language as requested on command line" 
else
	if [ "$langfromfile" = "english" ]; then
		docfile="default_index_en.tex"
	else
		docfile="default_index_de.tex"
	fi
fi

export TEXINPUTS="$TEXINPUTS:$template_path"
loadfile_cmd="\input{$docfile}"

pdfcommand="$loadfile_cmd"

pdflatex -interaction nonstopmode --jobname=out "$pdfcommand" 1>&5 2>&6
pdflatex -interaction nonstopmode --jobname=out "$pdfcommand" 1>&5 2>&6
makeindex out.idx 1>&5 2>&6 
pdflatex -interaction nonstopmode --jobname=out "$pdfcommand" 1>&5 2>&6
pdflatex -interaction nonstopmode --jobname=out "$pdfcommand" 1>&5 2>&6
chmod o+r out.pdf >&5 2>&6
chmod o+r out.log >&5 2>&6

if [ ! -e "out.pdf" ]; then
	fail "Creation of out.pdf failed"
fi

if [ ! -z "$target_doc" ]; then
	echo "Copy document to '$target_doc'"
	cp out.pdf "$target_doc"
	if [ $? -ne 0 ]; then
		fail "Unable to copy out.pdf to '$target_doc'"
	fi
fi

ls out.* |grep -v ".aux" |xargs rm

#the following is necessary for EA2Latecx plugin to recognize end of processing
echo done
