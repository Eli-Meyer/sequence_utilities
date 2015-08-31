#!/usr/bin/perl
# written by E Meyer, eli.meyer@science.oregonstate.edu
# distributed without any guarantees or restrictions

$scriptname=$0; $scriptname =~ s/.+\///g;
if ($#ARGV != 4 || $ARGV[0] eq "-h") 
	{
	print "\nGenerates random sequences (DNA or protein, as specified by the user).\n";
	print "Usage: $scriptname number option length type output\n"; 
	print "\t(e.g. $scriptname 10 r 200 DNA random_dna.fasta)\n"; 
	print "Where:\tnumber =\tnumber of sequences to generate.\n";
	print "\toption =\tf for fixed, uniform length, r for random lengths.\n";
	print "\tlength =\taverage length of random sequences.\n";
	print "\ttype =\t\tDNA or protein.\n";
	print "\toutput =\ta name for the output file.\n\n";
	exit;
	}

use Bio::SeqIO;
use Bio::Seq;

my $nout = $ARGV[0];
my $opt = $ARGV[1];
my $val = $ARGV[2];
my $type = $ARGV[3];
my $outfile = $ARGV[4]; my $outseqs = new Bio::SeqIO(-file=>">$outfile", -format=>'fasta');

if ($type eq "DNA")
	{
	@bases = qw{A C G T};
	$range = 4;
	}
elsif ($type eq "protein")
	{
	@bases = qw{A C D E F G H I K L M N P Q R S T V W Y};
	$range = 20;	
	}

for ($i = 1; $i <= $nout; $i++)
	{
	if ($opt eq "f")
		{@ostr = ();
		for ($j = 1; $j <= $val; $j++)
			{$jrnd = int(rand($range));
			$brnd = $bases[$jrnd];
			push @ostr, $brnd;
			}
		$jstr = join("", @ostr);
		$jid = "RandomSeq".$i;
#		print $jid, "\t", $jstr, "\n";
		if ($type eq "DNA")
			{
	 		$so = Bio::Seq->new(-seq=>$jstr, -alphabet=>'dna', -display_id=>$jid);
			}
		elsif ($type eq "protein")
			{
	 		$so = Bio::Seq->new(-seq=>$jstr, -alphabet=>'protein', -display_id=>$jid);
			}
		$outseqs->write_seq($so);
		}
	if ($opt eq "r")
		{@ostr = ();
		$max = 2 * $val;
		$klen = int(rand($max))+1;
		for ($j = 1; $j <= $klen; $j++)
			{$jrnd = int(rand($range));
			$brnd = $bases[$jrnd];
			push @ostr, $brnd;
			}
		$jstr = join("", @ostr);
		$jid = "RandomSeq".$i;
		if ($type eq "DNA")
			{
	 		$so = Bio::Seq->new(-seq=>$jstr, -alphabet=>'dna', -display_id=>$jid);
			}
		elsif ($type eq "protein")
			{
	 		$so = Bio::Seq->new(-seq=>$jstr, -alphabet=>'protein', -display_id=>$jid);
			}
		$outseqs->write_seq($so);
		}
	}

