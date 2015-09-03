#!/usr/bin/perl
# written by E Meyer, eli.meyer@science.oregonstate.edu
# distributed without any guarantees or restrictions

$scriptname=$0; $scriptname =~ s/.+\///g;
if ($#ARGV != 0 || $ARGV[0] eq "-h") 
	{
	print "\nExcludes the sequences identified in a user supplied list from the FASTA file\n";
	print "supplied by the user.\n";
	print "Usage: $scriptname list input > output\n"; 
	print "Where:\tlist:\ta list of sequence IDs\n";
	print "\tinput:\ta FASTA file containing multiple sequences.\n";
	print "\toutput:\ta name for the output file (all sequences from input not named in list)\n\n";
	exit;
	}

# -- check for dependencies
$mod1="Bio::SeqIO";
unless(eval("require $mod1")) {print "$mod1 not found. Exiting\n"; exit;} 
use Bio::SeqIO;

my $lfile = $ARGV[0]; open (LIST, $lfile); @list = <LIST>; close (LIST);
my $seqfile = $ARGV[1]; my $seq_set = new Bio::SeqIO(-file=>$seqfile, -format=>'fasta'); 

my %avdh = ();
foreach $l (@list) {chomp($l); $avdh{$l} = 1;}

while (my $seq = $seq_set->next_seq)
	{my $str = $seq->seq;
	my $ID = $seq->display_id;
	my $dsc = $seq->description;
	if ($ID eq "") {next;}
	unless (exists($avdh{$ID}))
		{print ">".$ID." ".$dsc."\n".$str."\n";
		}
	}
