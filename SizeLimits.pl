#!/usr/bin/perl
# written by E Meyer, eli.meyer@science.oregonstate.edu
# distributed without any guarantees or restrictions

# -- check arguments and print usage statement
$scriptname=$0; $scriptname =~ s/.+\///g;
$usage = <<USAGE;
Applies length limits to a collection of sequences, keeping all sequences above
or below the specified limit. 
Usage: $scriptname input threshold option output
Where:
	input:		a FASTA file containing multiple sequences
	threshold:	the molecular weight threshold (bp or amino acids)
	option:		"g" = keep sequences greater than the threshold. 
			"l" keeps sequenced below threshold.
	output:		a name for the output file (FASTA format)
USAGE
if ($#ARGV != 3 || $ARGV[0] eq "-h") {print "\n", "-"x60, "\n", $scriptname, "\n", $usage, "-"x60, "\n\n"; exit;}

# -- module and executable dependencies
# use this block if checking for executable dependencies
# copy the block and edit to check for additional Perl modules required by the script
$mod1="File::Which";
unless(eval("require $mod1")) {print "$mod1 not found. Exiting\n"; exit;}
use File::Which;
$mod2="Bio::SeqIO";
unless(eval("require $mod2")) {print "$mod2 not found. Exiting\n"; exit;}
use Bio::SeqIO;

my $ifil = $ARGV[0];
my $iseq = new Bio::SeqIO(-file=>$ifil, -format=>'fasta');
my $thd = $ARGV[1];
my $opt = $ARGV[2];
my $ofil = $ARGV[3];
my $oseq = new Bio::SeqIO(-file=>">$ofil", -format=>'fasta');

while (my $seq = $iseq->next_seq)
	{my $bp = $seq->length;
	if ($opt eq "g")
		{if ($bp >= $thd) {$oseq->write_seq($seq);}}
	if ($opt eq "l")
		{if ($bp <= $thd) {$oseq->write_seq($seq);}}
	}
