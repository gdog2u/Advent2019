use strict;
use warnings;
use v5.10;

my @tests = (
	122345,
	123444,
	111111,
	111122,
	122111,
	224444,
	223450,
	123789
);

open(my $fh, "<", "input.txt");
my $line = <$fh>;
close($fh);

my ($min, $max) = split(/\-/, $line);

# for my $pass (@tests)
# {
	# if(isValidPass($pass)){ say "$pass IS a valid password"; }
	# say "$pass ".(isValidPass($pass) ? "IS" : "IS NOT")." a valid password";
# }

my $totalValid = 0;
for(my $i = $min; $i < $max; $i++)
{
	if(isValidPass($i))
	{
		$totalValid++;
		warn "$i is a valid password";
	}
}

say "Total valid passwords: ".$totalValid;

# Validate whether or not a six-digit number is a valid password
sub isValidPass
{
	if($_[0] !~ /^\d{6}$/){ return 0; }
	
	my @potential = split(//, $_[0]);
	
	# Make sure all digits are ascending
	for(my $i = 0; $i < scalar @potential - 1; $i++)
	{
		if($potential[$i] > $potential[$i+1]){ return 0; }
	}
	
	# Check for ONLY double digits
	my %appearanceCount = ();
	for(my $i = 0; $i < scalar @potential; $i++)
	{
		$appearanceCount{$potential[$i]}++;
	}
	
	my @t = grep{ $appearanceCount{$_} == 2 } keys %appearanceCount;
	
	# Can return double since it will be true or false anyway
	return scalar @t > 0 ? 1: 0;
}