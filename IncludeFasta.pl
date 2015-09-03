#!/usr/bin/perl
# written by E Meyer, eli.meyer@science.oregonstate.edu
# distributed without any guarantees or restrictions

$scriptname=$0; $scriptname =~ s/.+\///g;
if ($#ARGV != 2 || $ARGV[0] eq "-h") 
	{
	print "\nExcludes the sequences identified in a user supplied list from the FASTA file\n";
	print "supplied by the user.\n";
	print "Usage: $scriptname list input output\n"; 
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
my $seqfile = $ARGV[1]; 
my $outfile = $ARGV[2];
my $seq_set = new Bio::SeqIO(-file=>$seqfile, -format=>'fasta'); 
my %shash = ();
my %dhash = ();

my %qh; my $scount = 0;
foreach $s (@list)
	{$scount++;
	chomp($s);
	$s =~ s/\s.+//g;
	$qh{$s} = $scount;
	}
print $scount, " entries in list\n";

my %oh;
while (my $seq = $seq_set->next_seq)
	{
	$seqcount++;
	$ID = $seq->display_id;
	if (exists($qh{$ID}))
		{
		$nomcount++;
		$str = $seq->seq;
		$dsc = $seq->description;
		$oh{$ID}{"dsc"} = $dsc;
		$oh{$ID}{"rank"} = $qh{$ID};
		$oh{$ID}{"seq"} = $str;
		}
#	else {print $ID, "\n";}
#	else {print $ID, "\n";}
	}
print $seqcount, " sequences in input\n";
print $nomcount, " sequence IDs match list\n";

@osl = sort {$oh{$a}{"rank"} <=> $oh{$b}{"rank"}} (keys (%oh));
open(OUT, ">$outfile");
foreach $os (@osl)
	{
	print OUT ">", $os, " ", $oh{$os}{"dsc"}, "\n";
	print OUT $oh{$os}{"seq"}, "\n";
	}
