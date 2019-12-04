use warnings;
use strict;
use Data::Dumper;
use List::MoreUtils qw{any duplicates};
use v5.10;

# my %test1 = (
	# "wire_1" => {
		# "directions" => "R75,D30,R83,U83,L12,D49,R71,U7,L72",
		# "points" => []
	# },
	# "wire_2" => {
		# "directions" => "U62,R66,U55,R34,D71,R55,D58,R83",
		# "points" => []
	# },
	# "matches" => []
# );

# my %test1 = (
	# "wire_1" => {
		# "directions" => "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
		# "points" => []
	# },
	# "wire_2" => {
		# "directions" => "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7",
		# "points" => []
	# },
	# "matches" => []
# );

my %input = (
	"wire_1" => {
		"directions" => "",
		"points" => []
	},
	"wire_2" => {
		"directions" => "",
		"points" => []
	},
	"matches" => []
);

# Read directions from input file
open(my $fh, "<", "input.txt");
$input{wire_1}{directions} = <$fh>;
$input{wire_2}{directions} = <$fh>;
close($fh);

# Plot the points per each set of directions
warn "Plotting wire 1";
$input{wire_1}{points} = plotPoints($input{wire_1}{directions});
warn "Plotting wire 2";
$input{wire_2}{points} = plotPoints($input{wire_2}{directions});

# Find the matches (intersections) between the two sets of points
warn "Finding wire intersections";
$input{matches} = findMatches($input{wire_1}{points}, $input{wire_2}{points});

# Find the distances between the source (0,0) and these intersections
warn "Finding closest intersection";
my $shortest = 999999999;
my $shortestMatch = "";
for(my $i = 0; $i < scalar @{ $input{matches} }; $i++)
{
	my $dist = getTaxiGeometry($input{matches}[$i]);
	if($dist < $shortest)
	{
		$shortest = $dist;
		$shortestMatch = $input{matches}[$i];
	}
}

# Output the shortest distance
say $shortest;

sub plotPoints
{
	my @directions = split(/,/, $_[0]);
	
	my $x = 0;
	my $y = 0;
	my @points = ();
	
	for my $d (@directions)
	{
		my ($cardinal, $dist) = split(/(\d+)/, $d);
		
		my $axisRef; 	# The axis we're modifying
		my $sign; 		# Adding or subtracting
		
		# Determine the axis we're modifying, as well as whether we'll be adding for subtracting
		if($cardinal eq "U")
		{
			$axisRef = \$y;
			$sign = "+";
		}
		elsif($cardinal eq "R")
		{
			$axisRef = \$x;
			$sign = "+";
		}
		elsif($cardinal eq "D")
		{
			$axisRef = \$y;
			$sign = "-";
		}
		elsif($cardinal eq "L")
		{
			$axisRef = \$x;
			$sign = "-";
		}
		
		# Increment our axis, and plot our points to an array
		for(my $i = 1; $i <= $dist; $i++)
		{
			my $newAxisValue = eval("$$axisRef $sign $i");
			if($cardinal =~ /U|D/){ push(@points, "$x,$newAxisValue"); }
			else{ push(@points, "$newAxisValue,$y"); }
		}
		
		$$axisRef = eval("$$axisRef $sign $dist");
	}
	
	return \@points;
}

sub findMatches
{
	my @a = @{ $_[0] };
	my @b = @{ $_[1] };
	
	my @matches = ();
	
	push(@a, @b);
	
	@matches = duplicates(sort @a);
	
	return \@matches;
}

sub getTaxiGeometry
{
	my ($x, $y) = split(/,/, $_[0]);
	
	return abs(0 - $x) + abs(0 - $y);
}