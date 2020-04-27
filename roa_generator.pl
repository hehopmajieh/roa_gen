#!/usr/bin/perl

use strict;
use warnings;
use Net::IRR;
use Getopt::Long qw(GetOptions);
use Data::Dumper qw(Dumper);
use POSIX qw(strftime);

my $date = strftime "%m/%d/%Y", localtime;
my $host = 'whois.neterra.net';
my @routes;
#debug statement , disable if unneded
my $debug=0;
my $irr = Net::IRR->connect( host => $host ) or die "Cannot connect to $host\n";
my $roa_name;
my $input;

GetOptions('list=s' => \$input,'roa_name=s'=>\$roa_name) or die "usage: $0 [options]\n";
if ($input && $roa_name) {
	print "Check input for valid AS-SET \n" if $debug;
	if (check_if_asset($input)) { 
		print "Valid AS-SET found \n" if $debug;
		get_as_set($input);
	} else {
		print "Expecting as-list \n" if $debug;
		my @asns = split / /, $input;
		get_as_list(@asns);		
	}

} else {
	print "$0 Usage: \n";
	print "--list  not defined, argument is mandatory\n";
	print "--name  not defined, argument is mandatory\n";
	print "Usage: $0 --list 'AS-SET| AS-LIST' --roa_name 'roa table name' --out 'path to save' \n";

}
 
sub check_if_asset{
	my $in = $_[0]; 
	if (my @ases = $irr->get_as_set($in, 1)) {
		return 1;
	} else {
		return 0;
	}
}

sub get_as_list {
	my @ases = @_;
	print "#--------------Generated at :".strftime("%Y-%m-%d %H:%M:%S",localtime)."--------------\n";
	print "roa table r$roa_name {\n";
	foreach my $as (@ases) {
        push(@routes, $irr->get_routes_by_origin($as));

	my @aggedroutes = aggregate(\@routes);
    foreach my $route (@aggedroutes) {
        	print "\troa $route max 32 as $as;\n";
		}
	}
	print "}\n";
	

}


sub get_as_set {
	my $asset = $_[0];
	my @ases = $irr->get_as_set($asset, 1);
	print "#--------------Generated at :".strftime("%Y-%m-%d %H:%M:%S",localtime)."--------------\n";
	print "roa table r$roa_name {\n";
	foreach my $as (@ases) {
    	push(@routes, $irr->get_routes_by_origin($as));
	my @aggedroutes = aggregate(\@routes);
	foreach my $route (@aggedroutes) {
    	    print "\t roa $route max 32 as $as;\n";
		}
	}
	print "}\n";
}

sub aggregate {
        use NetAddr::IP qw( Compact );
        my @naddr = map { NetAddr::IP->new($_) } @{$_[0]};
        my @output = Compact(@naddr);
        return @output;
}

#__EOF__
