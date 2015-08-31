#!/usr/bin/perl
# written by E Meyer, eli.meyer@science.oregonstate.edu
# distributed without any guarantees or restrictions

$scriptname=$0; $scriptname =~ s/.+\///g;
if ($#ARGV != 2 || $ARGV[0] eq "-h") 
	{
	print "\nSummarizes length distribution for a collection of DNA sequences (FASTA)\n";
	print "Usage: $scriptname input max_bin bin_size\n"; 
	print "Where:\tinput:\tFASTA-formatted file containing multiple DNA sequences.\n";
	print "\tmax_bin:\tsequences longer than this will all be counted in the largest bin.\n";
	print "\tbin_size:\tsize of each bin in bp.\n\n";
	exit;
	}
use Bio::SeqIO;

unless ($#ARGV==2) {print "Usage: script input max_bin bin_size\n"; exit;}

$maxbin = $ARGV[1];
$binsize = $ARGV[2];
$binn = $maxbin / $binsize;
@bins = ();
for ($a=0; $a<=$binn; $a++) 
	{
	$bini = $a * $binsize;
	push @bins, $bini;
	}
#print "@bins\n";

my $inseqs = new Bio::SeqIO(-file=>"$ARGV[0]", format=>"fasta");
while($seq = $inseqs->next_seq)
	{
	$count++;
	$loopcount = 0;
	foreach $b (@bins)
		{
		if ($b < $maxbin)
			{
			if ($seq->length>=$b && $seq->length<$bins[$loopcount+1])
				{
				$ch{$bins[$loopcount]}++;
				last;
				}
			}
		elsif ($b == $maxbin)
			{
			if ($seq->length>=$b)
				{
				$ch{$maxbin}++;
				last;
				}
			}
		$loopcount++;
		}
	}

print "Min(bp)\tMax(bp)\tNumber\n";
foreach $b (sort{$a<=>$b}(keys(%ch)))
	{
	if ($b eq $maxbin)
		{
		print $b, "\t", "Inf", "\t", $ch{$b}, "\n";
		}
	else
		{
		print $b, "\t", $b+$binsize, "\t", $ch{$b}, "\n";
		}
	}
