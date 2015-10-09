#!/usr/bin/perl
# written by E Meyer, eli.meyer@science.oregonstate.edu
# distributed without any guarantees or restrictions

# -- check arguments and print usage statement
$scriptname=$0; $scriptname =~ s/.+\///g;
$usage = <<USAGE;
Replaces illegal characters in a fasta formatted sequence with a new character specified by the user.
Usage: $scriptname input sequence_type replacement
Where:  input:		name of input file.
        sequence_type:	pro = protein; nucleic acids: nuc=A, C, G, T, or N; amb=IUPAC ambiguity allowed (e.g. R, Y)
        replacement:	replace illegal characters with this character.

USAGE
if ($#ARGV != 2 || $ARGV[0] eq "-h") {print "\n", "-"x60, "\n", $scriptname, "\n", $usage, "-"x60, "\n\n"; exit;}

$opt = $ARGV[1];
$rep = $ARGV[2];

@legal_a = qw{A C G T U M R W S Y K V H D B N};
foreach $l (@legal_a) {$legal_ah{$l}++;}

@legal_n = qw{A C G T N};
foreach $l (@legal_n) {$legal_nh{$l}++;}

@legal_p = qw{A B C D E F G H I K L M N P Q R S T V W X Y Z *};
foreach $l (@legal_p) {$legal_ph{$l}++;}

open(IN, $ARGV[0]);
while(<IN>)
	{
	chomp;
	if ($_ =~ /^>/)	{print $_, "\n";}
	else
		{
		@chars = split("", $_);
		foreach $c (@chars)
			{
			$c =~ tr/[a-z]/[A-Z]/;
			if ($c =~ /\s/) {print $c; next;}
			if ($opt eq "nuc")
				{
				if (exists($legal_nh{$c}))	{print $c; next;}
				else	{print $rep; next;}
				}
			if ($opt eq "amb")
				{
				if (exists($legal_ah{$c}))	{print $c; next;}
				else	{print $rep; next;}
				}
			elsif ($opt eq "pro")
				{
				if (exists($legal_ph{$c}))	{print $c; next;}
				else	{print $rep; next;}
				}
			}
		print "\n";
		}
	}
close(IN);
