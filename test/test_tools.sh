# /bin/bash

tmpdir=_tmp_test_tools
LOG=$tmpdir/_test_tools.log
SEP='--------------------------------------------------------------------------------'

mkdir -p $tmpdir
mkdir -p $tmpdir/FASTQs
mkdir -p $tmpdir/db

nreads=1000000

echo '\n' | tee -a $LOG
echo `date` | tee -a $LOG
echo '\n' | tee -a $LOG

echo ' - downloading Hi-C experiments 1/3' | tee -a $LOG
             #sample ID #no quality header #sequence header #split reads #quality filter #quality filter #stop download after 1M
fastq-dump -A SRR4433970 -DQ '+' --defline-seq '@$ac.$si' --split-files --qual-filter --qual-filter-1 -X $nreads
mv  SRR4433970_1.fastq $tmpdir/FASTQs/SRR4433970a_1.fastq
mv  SRR4433970_2.fastq $tmpdir/FASTQs/SRR4433970a_2.fastq

echo ' - downloading Hi-C experiments 2/3' | tee -a $LOG
             #sample ID #no quality header #sequence header #split reads #quality filter #quality filter #start download after 1M #stop downnload after 2M
fastq-dump -A SRR4433970 -DQ '+' --defline-seq '@$ac.$si' --split-files --qual-filter --qual-filter-1 -N $nreads -X $((nreads/2))
mv  SRR4433970_1.fastq $tmpdir/FASTQs/SRR4433970b_1.fastq
mv  SRR4433970_2.fastq $tmpdir/FASTQs/SRR4433970b_2.fastq

echo ' - downloading Hi-C experiments 3/3' | tee -a $LOG
fastq-dump -A SRR4433971 -DQ '+' --defline-seq '@$ac.$si' --split-files -E  --qual-filter-1 -X $((nreads*2))
mv  SRR4433971_1.fastq $tmpdir/FASTQs/SRR4433971_1.fastq
mv  SRR4433971_2.fastq $tmpdir/FASTQs/SRR4433971_2.fastq

echo '\n' | tee -a $LOG
echo `date` | tee -a $LOG
echo '\n' | tee -a $LOG

echo ' - downloading Yeast genome' | tee -a $LOG
wget http://hgdownload.soe.ucsc.edu/goldenPath/sacCer3/bigZips/chromFa.tar.gz

echo ''
echo ' - uncompressing Yeast genome' | tee -a $LOG
tar xzvf chromFa.tar.gz --to-stdout > $tmpdir/db/yeast.fa
rm -f chromFa.tar.gz

echo ''
echo ' - indexing' | tee -a $LOG
gem-indexer -i $tmpdir/db/yeast.fa -o $tmpdir/db/yeast

echo '\n' | tee -a $LOG
echo `date` | tee -a $LOG
echo '\n' | tee -a $LOG

BEGIN=$(date +%s);


################################# TADbit ######################################

# TADbit map
START=$(date +%s);
echo '' | tee -a $LOG
echo 'Mapping\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit map $tmpdir/rep1 --fastq $tmpdir/FASTQs/SRR4433970a_1.fastq --read 1 --index $tmpdir/db/yeast.gem --renz Sau3AI | tee -a $LOG
tadbit map $tmpdir/rep1 --fastq $tmpdir/FASTQs/SRR4433970a_1.fastq --read 1 --index $tmpdir/db/yeast.gem --renz Sau3AI 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

START=$(date +%s);
echo $SEP"\n   $ " tadbit map $tmpdir/rep1 --fastq $tmpdir/FASTQs/SRR4433970a_2.fastq --read 2 --index $tmpdir/db/yeast.gem --renz Sau3AI | tee -a $LOG
tadbit map $tmpdir/rep1 --fastq $tmpdir/FASTQs/SRR4433970a_2.fastq --read 2 --index $tmpdir/db/yeast.gem --renz Sau3AI 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

START=$(date +%s);
echo $SEP"\n   $ " tadbit map $tmpdir/rep1 --fastq $tmpdir/FASTQs/SRR4433970b_1.fastq --read 1 --index $tmpdir/db/yeast.gem --renz Sau3AI | tee -a $LOG
tadbit map $tmpdir/rep1 --fastq $tmpdir/FASTQs/SRR4433970b_1.fastq --read 1 --index $tmpdir/db/yeast.gem --renz Sau3AI 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

START=$(date +%s);
echo $SEP"\n   $ " tadbit map $tmpdir/rep1 --fastq $tmpdir/FASTQs/SRR4433970b_2.fastq --read 2 --index $tmpdir/db/yeast.gem --renz Sau3AI | tee -a $LOG
tadbit map $tmpdir/rep1 --fastq $tmpdir/FASTQs/SRR4433970b_2.fastq --read 2 --index $tmpdir/db/yeast.gem --renz Sau3AI 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

START=$(date +%s);
echo $SEP"\n   $ " tadbit map $tmpdir/rep2 --fastq $tmpdir/FASTQs/SRR4433971_1.fastq  --read 1 --index $tmpdir/db/yeast.gem --renz HindIII | tee -a $LOG
tadbit map $tmpdir/rep2 --fastq $tmpdir/FASTQs/SRR4433971_1.fastq  --read 1 --index $tmpdir/db/yeast.gem --renz HindIII 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

START=$(date +%s);
echo $SEP"\n   $ " tadbit map $tmpdir/rep2 --fastq $tmpdir/FASTQs/SRR4433971_2.fastq  --read 2 --index $tmpdir/db/yeast.gem --renz HindIII | tee -a $LOG
tadbit map $tmpdir/rep2 --fastq $tmpdir/FASTQs/SRR4433971_2.fastq  --read 2 --index $tmpdir/db/yeast.gem --renz HindIII 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# TADbit parse
START=$(date +%s);
echo '' | tee -a $LOG
echo $SEP"\n"$SEP | tee -a $LOG
echo 'Parsing 1/2\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit parse $tmpdir/rep1 --genome $tmpdir/db/yeast.fa | tee -a $LOG
tadbit parse $tmpdir/rep1 --genome $tmpdir/db/yeast.fa 2>> $LOG
echo 'Parsing 2/2\n'
echo $SEP"\n   $ " tadbit parse $tmpdir/rep2 --genome $tmpdir/db/yeast.fa | tee -a $LOG
tadbit parse $tmpdir/rep2 --genome $tmpdir/db/yeast.fa 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# TADbit filter
START=$(date +%s);
echo '' | tee -a $LOG
echo $SEP"\n"$SEP | tee -a $LOG
echo 'Filtering 1/2\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit filter $tmpdir/rep1 | tee -a $LOG
tadbit filter $tmpdir/rep1  2>> $LOG
echo 'Filtering 2/2\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit filter $tmpdir/rep2 | tee -a $LOG
tadbit filter $tmpdir/rep2 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# TADbit normalize
START=$(date +%s);
echo '' | tee -a $LOG
echo $SEP"\n"$SEP | tee -a $LOG
echo 'Normalizing 1/2\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit normalize $tmpdir/rep1 -r 100000 | tee -a $LOG
tadbit normalize $tmpdir/rep1 -r 100000 2>> $LOG
echo 'Normalizing 2/2\n'
echo $SEP"\n   $ " tadbit normalize $tmpdir/rep2 -r 100000 --min_count 100 | tee -a $LOG
tadbit normalize $tmpdir/rep2 -r 100000 --min_count 100 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# TADbit merge
START=$(date +%s);
echo '' | tee -a $LOG
echo $SEP"\n"$SEP | tee -a $LOG
echo 'Merging\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit merge $tmpdir/both -w1 $tmpdir/rep1 -w2 $tmpdir/rep2 -r 100000 --norm | tee -a $LOG
tadbit merge $tmpdir/both -w1 $tmpdir/rep1 -w2 $tmpdir/rep2 -r 100000 --norm 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# TADbit normalize
START=$(date +%s);
echo '' | tee -a $LOG
echo $SEP"\n"$SEP | tee -a $LOG
echo 'Normalizing\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit normalize $tmpdir/both -r 100000 | tee -a $LOG
tadbit normalize $tmpdir/both -r 100000 2>> $LOG
echo $SEP"\n   $ " tadbit normalize $tmpdir/both -r 10000 | tee -a $LOG
tadbit normalize $tmpdir/both -r 10000 2>> $LOG
echo $SEP"\n   $ " tadbit normalize $tmpdir/both -r 20000 --min_count 10 | tee -a $LOG
tadbit normalize $tmpdir/both -r 20000 --min_count 10 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# TADbit bin
START=$(date +%s);
echo '' | tee -a $LOG
echo $SEP"\n"$SEP | tee -a $LOG
echo 'Binning\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit bin $tmpdir/both -r 100000 -c chrII --norm raw norm decay | tee -a $LOG
tadbit bin $tmpdir/both -r 100000 -c chrII --norm raw norm decay 2>> $LOG
echo $SEP"\n   $ " tadbit bin $tmpdir/both -r 100000 -c chrIII -c2 chrVII:100000-1000000 | tee -a $LOG
tadbit bin $tmpdir/both -r 100000 -c chrIII -c2 chrVII:100000-1000000 2>> $LOG
echo $SEP"\n   $ " tadbit bin $tmpdir/both -r 100000 --plot --matrix | tee -a $LOG
tadbit bin $tmpdir/both -r 100000 --plot --matrix 2>> $LOG
echo $SEP"\n   $ " tadbit bin $tmpdir/both -r 20000  --norm norm | tee -a $LOG
tadbit bin _tmp_test_tools/both -r 20000 --norm norm 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# TADbit segment
START=$(date +%s);
echo '' | tee -a $LOG
echo $SEP"\n"$SEP | tee -a $LOG
echo 'TADs/compartments\n' | tee -a $LOG
echo $SEP"\n   $ " tadbit segment $tmpdir/both -r 10000 --fasta $tmpdir/db/yeast.fa | tee -a $LOG
tadbit segment $tmpdir/both -r 10000 --fasta $tmpdir/db/yeast.fa 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# TADbit model
START=$(date +%s);
echo '' | tee -a $LOG
echo $SEP"\n"$SEP | tee -a $LOG
echo 'Modelling: parameter optimization.\n' | tee -a $LOG  # Estimated time: 6 min
echo $SEP"\n   $ " tadbit model -w $tmpdir/both --optimize --beg 0 --end 1360022 --reso 20000 --maxdist 400:500:100 --upfreq=-0.2:0:0.1 --lowfreq=-0.4:-0.2:0.1 --nmodels 20 --nkeep 20 -j 8 --cpu 8 | tee -a $LOG
tadbit model -w $tmpdir/both --optimize --beg 0 --end 1360022 --reso 20000 --maxdist 400:500:100 --upfreq=-0.2:0:0.1 --lowfreq=-0.4:-0.2:0.1 --nmodels 20 --nkeep 20 -j 8 --cpu 8 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

START=$(date +%s);
echo 'Modelling: model generation.\n' | tee -a $LOG  # Estimated time: 2 min
echo $SEP"\n   $ " tadbit model -w $tmpdir/both --model --project test --species 'Saccharomyces cerevisiae' --assembly 'R64-1-1' --beg 0 --end 1360022 --reso 20000 --nmodels 200 --nkeep 200 -j 8 --cpu 8 | tee -a $LOG
tadbit model -w $tmpdir/both --model --project test --species 'Saccharomyces cerevisiae' --assembly 'R64-1-1' --beg 0 --end 1360022 --reso 20000 --nmodels 200 --nkeep 200 -j 8 --cpu 8 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

START=$(date +%s);
echo 'Modelling: model analysis.\n' | tee -a $LOG  # Estimated time: 2 min
echo $SEP"\n   $ " tadbit model --analyze -w $tmpdir/both --fig_format png -j 11 | tee -a $LOG
tadbit model --analyze -w $tmpdir/both --fig_format png -j 11 2>> $LOG
END=$(date +%s)
echo $((END-START)) | awk '{print "=> done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

# Done

echo $SEP"\n"$SEP | tee -a $LOG

echo '\n' | tee -a $LOG
echo `date` | tee -a $LOG
echo '\n' | tee -a $LOG


END=$(date +%s)
echo $((END-BEGIN)) | awk '{print "TADbit done in: " int($1/60)"m "int($1%60)"s"}' | tee -a $LOG

errors=`grep -ic error $LOG`

echo "\n\n -> Found" $errors "errors\n" | tee -a $LOG


if [ $errors -eq 0 ]
then
    echo 'Cleanning temporary directory'
    while true; do
        read -p "Remove temporary folder [Y]?" yn
        case $yn in
            ""    ) echo '\n            ... Removing'; rm -rf $tmpdir; break;;
            [Yy]* ) echo '\n            ... Removing'; rm -rf $tmpdir; break;;
            [Nn]* ) echo '\n            Have fun with the resuts!!'; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
else
    echo '  ==>> Check LOG in: ' $LOG 'for details'
fi

echo "Done."
