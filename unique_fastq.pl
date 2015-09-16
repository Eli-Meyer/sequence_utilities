#!/usr/bin/perl
# written by E Meyer, eli.meyer@science.oregonstate.edu
# distributed without any guarantees or restrictions

$scriptname=$0; $scriptname =~ s/.+\///g;
if ($#ARGV != 1 || $ARGV[0] eq "-h") 
	{
	print "\nExtracts unique sequences from a fastq file, eliminating duplicated records.\n";
	print "Usage: $scriptname input.fastq output.fastq\n"; 
	print "Where:\n";
	print "\tinput.fastq:\tFASTQ input file.\n";
	print "\toutput.fastq:\ta name for the output file, a FASTQ file without any duplicated records.\n\n";
	exit;
	}

# -- define variables from user input
$inseq = $ARGV[0];
$outseq = $ARGV[1];

# -- loop through fastq file and check if a record has been previously read
# -- only print records the first time a sequence ID is encountered
open (IN, $inseq);
open (OUT, ">$outseq");
my $status = 0;
my $switch = 0;
while(<IN>)
	{
	chomp;
	$count++;
	if ($count==1) {$ss = substr($_, 0, 8);}
	if ($_ =~ /^$ss/) 
		{
		$seqid = $_;
		$seqid =~ s/\s+.*//;
		$seqid =~ s/^@//;
		if (exists($lh{$seqid}))
			{
			$status = 0;
			next;
			}
		else	
			{$status = 1;}
		if ($status == 1) 
			{
			print OUT $_, "\n";
			$lh{$seqid}++;
			}
		next;
		}
	else
		{
		if ($status == 1) {print OUT $_, "\n";}
		next;
		}
	}
close(IN);
