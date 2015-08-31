This repository contains a series of scripts used for general DNA sequence analysis.
Several scripts also rely on the following software, which will need to be installed and in your path:
BioPerl			http://www.bioperl.org/wiki/Main_Page

The following usage information for each script can be reproduced by running each script without arguments.

Any questions or bugs? Please contact Eli Meyer: eli.meyer@science.oregonstate.edu.

-------------------------
FastaStats.pl
-------------------------

Summarizes length statistics for a set of DNA sequences.
Usage: FastaStats.pl input.fasta

-------------------------
RandSeqGen.pl
-------------------------

Generates random sequences (DNA or protein, as specified by the user).
Usage: RandSeqGen.pl number option length type output
	(e.g. RandSeqGen.pl 10 r 200 DNA random_dna.fasta)
Where:	number =	number of sequences to generate.
	option =	f for fixed, uniform length, r for random lengths.
	length =	average length of random sequences.
	type =		DNA or protein.
	output =	a name for the output file.

-------------------------
SeqLengthDist.pl
-------------------------

Summarizes length distribution for a collection of DNA sequences (FASTA)
Usage: SeqLengthDist.pl input max_bin bin_size
Where:	input:	FASTA-formatted file containing multiple DNA sequences.
	max_bin:	sequences longer than this will all be counted in the largest bin.
	bin_size:	size of each bin in bp.

