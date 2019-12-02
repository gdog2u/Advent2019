use warnings;
use strict;
use v5.10;

my @baseMemory = parseInput("input.txt");

for(my $noun = 0; $noun <= 99; $noun++)
{
	for(my $verb = 0; $verb <= 99; $verb++)
	{
		my @copyMemory = @baseMemory;
		my $result = parseInstructions(\@copyMemory, $noun, $verb);
		
		if($result == 19690720)
		{
			say ((100*$noun)+$verb);
			say join(",", @copyMemory);
			exit;
		}
	}
}

sub parseInstructions
{
	my $instructions = $_[0];
	my $noun = $_[1];
	my $verb = $_[2];
	
	$instructions->[1] = $noun;
	$instructions->[2] = $verb;
	
	for(my $i = 0; $i < scalar @{ $instructions }; $i+=4)
	{
		if($instructions->[$i] eq "99")
		{
			$i = scalar @{ $instructions };
		}
		elsif($instructions->[$i] eq "1")
		{
			$instructions = add($instructions, $i);
		}
		elsif($instructions->[$i] eq "2")
		{
			$instructions = multiply($instructions, $i);
		}
		else
		{
			warn "What? Found op code $instructions->[$i]";
		}
	}
	
	return $instructions->[0];
}

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