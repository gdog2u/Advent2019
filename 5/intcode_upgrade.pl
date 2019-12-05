use warnings;
use strict;
use POSIX;
use v5.10;

my @test_multiply = split(/,/, "1002,4,3,4,33");
my @test_add = split(/,/, "0001,1,4,5,99,0");
my @test_io = split(/,/, "3,7,4,6,4,7,99,420");
my @test_multi = split(/,/, "3,3,1002,12,12,10,4,10,99,420");

# my @instructions = parseInput("input.txt");
my $input = 1;

my $pointerIncrement = 4;
for(my $i = 0; $i < scalar @test; $i+=$pointerIncrement)
{
	if($test[$i] eq "99")
	{
		$i = $#test;
	}
	elsif($test[$i] =~ /[12]$/)
	{
		@test = @{ parseArithmetic(\@test, $i) };
		$pointerIncrement = 4;
	}
	elsif($test[$i] =~ /[34]$/)
	{
		@test = @{ parseIO(\@test, $i, $input) };
		$pointerIncrement = 2;
	}
	else
	{
		warn "What? Found op code $test[$i]";
		continue;
	}
}

# for(my $i = 0; $i < scalar @instructions; $i+=4)
# {
	# if($instructions[$i] eq "99")
	# {
		# $i = $#instructions;
	# }
	# elsif($instructions[$i] =~ /01$/)
	# {
		# @instructions = @{ add(\@instructions, $i) };
	# }
	# elsif($instructions[$i] =~ /02$/)
	# {
		# @instructions = @{ multiply(\@instructions, $i) };
	# }
	# else
	# {
		# warn "What? Found op code $instructions[$i]";
	# }
# }

print join(",", @test);

sub parseArithmetic
{
	my $inst = $_[0];
	my $opCode = $inst->[$_[1]];
	my @paramModes = (0,0);
	if(length $opCode > 1)
	{
		$opCode = substr($opCode, -1, 1);
		@paramModes = reverse split(//, substr($inst->[$_[1]], 0, -2));
	}
	
	my $operand1_index = $_[1]+1;
	my $operand1 = ($paramModes[0]//0) == 0 ? $inst->[$inst->[$operand1_index]] : $inst->[$operand1_index];
	
	my $operand2_index = $_[1]+2;
	my $operand2 = ($paramModes[1]//0) == 0 ? $inst->[$inst->[$operand2_index]] : $inst->[$operand2_index];
	
	my $outputIndex = $_[1]+3;
	
	if($opCode == 1)
	{
		$inst->[$inst->[$outputIndex]] = $operand1 + $operand2;
	}
	elsif($opCode == 2)
	{
		$inst->[$inst->[$outputIndex]] = $operand1 * $operand2;
	}
	
	return $inst;
}

sub parseIO
{
	my $inst = $_[0];
	my $opCode = $inst->[$_[1]];
	my $ioIndex = $inst->[$_[1]+1];
	my $input = $_[2]//0;
	
	if($opCode == 3)
	{
		$inst->[$ioIndex] = $input;
	}
	elsif($opCode == 4)
	{
		printBox(32, "Output at index $_[1]: ".$inst->[$ioIndex]);

	}
	
	return $inst;
}

sub parseInput
{
	open(my $fh, "<", $_[0]);
	my $intString = <$fh>;
	close($fh);
	
	return split(/,/, $intString);
}

# Prints a pretty box to STDOUT with the provided message inside a box of the provided characters
sub printBox
{
	my $boxWidth = $_[0];
	my $message = $_[1];
	my $boxChar = $_[2] // "*";
	my $boxSideChar = $_[3] // $boxChar x 2;
		$boxSideChar = length $boxSideChar != 2 ? $boxChar x 2 : $boxSideChar;
	my $messageLength = length $message;
	my @spaces;
	
	if(!$boxWidth || $boxWidth < 5)
	{
		warn "You must provide a width for the box above 4";
		return 0;
	}
	if(!$message)
	{
		warn "Please provide a message to be displayed in the box.";
		return 0;
	}
	if(length $message > ($boxWidth-4))
	{
		warn "The provided message will not fit into the box with the width provided";
		return 0;
	}
	if($boxWidth%2==1)
	{
		warn "The box width must be a multiple of 2.";
		return 0;
	}
	
	@spaces = (' ' x ( (($boxWidth/2)-2)-(floor($messageLength/2)) ), ' ' x ( (($boxWidth/2)-2)-(ceil($messageLength/2)) ));
	print "\n";
	print $boxChar x ($boxWidth);
	print "\n$boxSideChar$spaces[0]$message$spaces[1]$boxSideChar\n";
	print $boxChar x ($boxWidth);
	print "\n";
}