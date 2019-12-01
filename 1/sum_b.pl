use v5.10;
use warnings;
use strict;

my @tests = (
	12,
	14,
	1969,
	100756
);

my @inputs = (
	94164 ,
	100562,
	114499,
	134308,
	138764,
	114494,
	70457 ,
	113793,
	117753,
	77795 ,
	110371,
	113357,
	118839,
	99757 ,
	119918,
	145232,
	147113,
	142411,
	93053 ,
	81783 ,
	124022,
	98470 ,
	77368 ,
	75163 ,
	79175 ,
	131174,
	93196 ,
	121875,
	86016 ,
	148758,
	126577,
	109812,
	105696,
	66318 ,
	146939,
	113236,
	130014,
	135719,
	127114,
	69700 ,
	109416,
	64168 ,
	89215 ,
	69015 ,
	128511,
	59682 ,
	79067 ,
	58795 ,
	145447,
	129419,
	93058 ,
	63860 ,
	146148,
	58364 ,
	74149 ,
	81871 ,
	116469,
	131739,
	132852,
	148040,
	98865 ,
	56588 ,
	79326 ,
	114713,
	52397 ,
	134887,
	114809,
	113356,
	60505 ,
	142323,
	84792 ,
	117079,
	147796,
	50196 ,
	148897,
	100794,
	50508 ,
	71023 ,
	149350,
	66679 ,
	93680 ,
	116069,
	133042,
	117291,
	127439,
	81598 ,
	93163 ,
	83964 ,
	64226 ,
	63026 ,
	82625 ,
	59589 ,
	94831 ,
	66807 ,
	120375,
	112108,
	83484 ,
	109892,
	66136 ,
	126794,
);

my $sum = 0;

for my $mass (@inputs)
{
	my $fuel = $mass;
	do
	{
		$fuel = getFuel($fuel);
		$sum += $fuel;
	}while($fuel != 0);
}

say $sum;

sub getFuel
{
	my $fuel = int($_[0]/3)-2;
	return $fuel < 0 ? 0 : $fuel;
}