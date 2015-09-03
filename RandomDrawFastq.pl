#!/usr/bin/perl
# written by E Meyer, eli.meyer@science.oregonstate.edu
# distributed without any guarantees or restrictions

$scriptname=$0; $scriptname =~ s/.+\///g;
if ($#ARGV != 2 || $ARGV[0] =~ "-h") 
	{
	print "\nDraws the specified number of sequences randomly from an input FASTQ file.\n";
	print "Usage: $scriptname input num_seq output\n\n"; 
	exit;
	}

# user input
$infile = $ARGV[0];
$todraw = $ARGV[1];
$outfile = $ARGV[2];

# count number of sequences in input
$nolines = `wc -l $infile`;
$nolines =~ s/\s.+//g;
chomp($nolines);
$noseqs = $nolines / 4;

if ($todraw >= $noseqs)
	{
	print "\nThere are only $noseqs sequences in $infile and you've asked to randomly draw $todraw.\n\n";
	exit;
	}

# generate list of sequence numbers to extract
%rh = ();
for ($a=1; $a<=$todraw; $a++)
	{
	$randi = 0;
	while ($randi eq 0 || exists($rh{$randi}))
		{
		$randi = int(rand($noseqs+1));
		}
	$rh{$randi}++;
#	print $randi, "\n";
	}

# loop through fastq file and print out randomly chosen sequence numbers
open (IN, $infile);
open (OUT, ">$outfile");
$state = 0; $seqcount = 0; $count = 0;
while(<IN>)
	{
	chomp;
	$count++;
	if ($count==1) {$ss = substr($_, 0, 4);}
	if ($_ =~ /^$ss/) 
		{
		$seqcount++;
		if (exists($rh{$seqcount}))
			{$state = 1;}
		else 	{$state = 0;}
		}
	if ($state eq 1) {print OUT $_, "\n";}
	}
close(IN);
