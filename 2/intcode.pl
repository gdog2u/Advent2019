use warnings;
use strict;
use v5.10;

# my $test = "1,9,10,3,2,3,11,0,99,30,40,50";
my $test_add = "1,0,0,0,99";
my $test_multiply = "2,3,0,3,99";
my $test_multiply2 = "2,4,4,5,99,0";
my $test = "1,1,1,4,99,5,6,0,99";

my @instructions = parseInput("input.txt");

for(my $i = 0; $i < scalar @instructions; $i++)
{
	if($instructions[$i] eq "99")
	{
		$i = $#instructions;
	}
	if($instructions[$i] eq "1")
	{
		@instructions = @{ add(\@instructions, $i) };
		$i+=4;
	}
	if($instructions[$i] eq "2")
	{
		@instructions = @{ multiply(\@instructions, $i) };
		$i+=4;
	}
}

print join(",", @instructions);

sub add
{
	my $inst = $_[0];
	my $op1 = $_[1]+1;
	my $op2 = $_[1]+2;
	my $outputIndex = $_[1]+3;
	
	$inst->[$inst->[$outputIndex]] = $inst->[$inst->[$op1]] + $inst->[$inst->[$op2]];
	
	return $inst;
}

sub multiply
{
	my $inst = $_[0];
	my $op1 = $_[1]+1;
	my $op2 = $_[1]+2;
	my $outputIndex = $_[1]+3;
	
	$inst->[$inst->[$outputIndex]] = $inst->[$inst->[$op1]] * $inst->[$inst->[$op2]];
	
	return $inst;
}

sub parseInput
{
	open(my $fh, "<", $_[0]);
	my $intString = <$fh>;
	close($fh);
	
	return split(/,/, $intString);
}