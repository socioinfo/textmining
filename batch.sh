#!/bin/bash

rm -rf DIV TXT WRD DAT freq.csv freq_5.csv all.csv all2.csv table.sed cluster.png

#echo ==== step 0 =============================================================
#if [ ! -d HTML ]; then mkdir HTML; fi
#cd HTML
#for f in `cat ../link.txt`; do
#	wget $f
#	sleep 1
#done
#cd ..

echo ==== step 1 =============================================================
if [ ! -d DIV ]; then mkdir DIV; fi
for f in HTML/*; do 
	./script.pl $f > DIV/`basename $f`
	echo $f
done

echo ==== step 2 =============================================================
if [ ! -d TXT ]; then mkdir TXT; fi
for f in DIV/*; do 
	w3m -cols 1000 -dump $f > TXT/`basename $f .html`.txt
	echo $f
done

# ======= step 2' =============================================================
cat TXT/20120717.txt | perl -nle 'if ($flag != 1) { if ($_ =~ /付録/)  { $flag = 1; }; print $_; }' > /tmp/x.txt
mv /tmp/x.txt TXT/20120717.txt

echo ==== step 3 =============================================================
if [ ! -d WRD ]; then mkdir WRD; fi
for f in TXT/*; do 
	cat $f | chasen | grep -v EOS | egrep -e '名詞|形容詞' | \
	egrep -v -e '名詞-数|非自立|接尾|固有名詞' | cut -f 1 | \
	sort > WRD/`basename $f .txt`.dat
	echo $f
done
for f in TXT/*; do 
	cat $f | sed -e 's/[^A-Za-z0-9 \/\:\-]/ /g' | sed -e 's/ /\n/g' | \
	sort -r | egrep -v -e '^$' >> WRD/`basename $f .txt`.dat
	echo $f
done

echo ==== step 4 =============================================================
cat WRD/* | sort | uniq -c | sort -nr | awk '{print $2,$1;}' | sed -e 's/ /,/g' > freq.csv
cat freq.csv | perl -nle '@x = split ",",$_; print $x[0] if $x[1] >= 5;' > freq_5.csv

if [ ! -d DAT ]; then mkdir DAT; fi
for f in WRD/*; do 
	./script2.pl $f > DAT/`basename $f .dat`.csv
	echo $f
done

cat DAT/* > all.csv

echo ==== step 5 =============================================================
echo -n creating all2.csv ...
cat table.csv | perl -nle '@x = split ",", $_; print "s/$x[0]/$x[1]/";' > table.sed
sed all.csv -f table.sed > all2.csv
echo done

echo ==== step 6 =============================================================
R < mkgraph.r --no-save

