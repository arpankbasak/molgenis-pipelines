#MOLGENIS nodes=1 ppn=1 mem=6gb walltime=23:59:00

#Parameter mapping  #why not string foo,bar? instead of string foo\nstring bar
#string stage
#string checkStage
#string WORKDIR
#string projectDir

#string markDuplicatesBam
#string markDuplicatesBai
#string genomeEnsembleAnnotationFile

#string samtoolsVersion
#string htseqVersion
#string htseqCountDir
#string htseqCountCounts

echo "## "$(date)" ##  $0 Started "


getFile ${markDuplicatesBam}
getFile ${markDuplicatesBai}

${stage} HTSeq/${htseqVersion}
${stage} SAMtools/${samtoolsVersion}
${checkStage}

set -x
set -e

mkdir -p ${htseqCountDir}

samtools view -h ${markDuplicatesBam} | $EBROOTHTSEQ/scripts/htseq-count -m union -s no -t exon -i gene_id - ${genomeEnsembleAnnotationFile} > ${htseqCountCounts}

putFile ${htseqCountCounts}

if [ ! -z "$PBS_JOBID" ]; then
	echo "## "$(date)" Collecting PBS job statistics"
	qstat -f $PBS_JOBID
fi

echo "## "$(date)" ##  $0 Done "
