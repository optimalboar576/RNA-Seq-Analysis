for i in `ls -1 *_1.fastq.gz | sed 's/\_1.fastq.gz//'`
do
echo
printf "Running Alignment for $i \n"
hisat2 -p 4 --dta -x /path/to/index/index_name -1 $i"_1.fastq.gz" -2 $i"_2.fastq.gz" -S $i".sam" 2>$i"log"
# e.g. hisat2 -p 8 --dta -x ./hg38_ht2/Human -1 $i"_1.fastq.gz" -2 $i"_2.fastq.gz" -S $i".sam" 2>$i"log"
printf "Finished Alignment for $i \n"
#rm $i"_1.fastq.gz" $i"_2.fastq.gz"
printf "Running Samtools for $i \n"
samtools view -S -b $i".sam">$i".bam" -@ 4
#rm $i".sam"
printf "Sorting $i \n"
samtools sort $i".bam" -o $i".sorted.bam" -@ 4
#rm $i".bam"
printf "Finished analysis for $i"
done

featureCounts -p -a /path/to/gtf -t exon -g gene_id -o countens.txt *sorted.bam

cp countens.txt count.tsv

sed 's/\t/,/g' count.tsv > count.csv

sed -i '1d' count.csv

