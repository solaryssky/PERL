#!/usr/bin/perl -ws
# This script parse standart apache log file by time interval

sub usage {
    printf "Usage: %s -s=<start time> [-e=<end time>] <logfile>\n";
    die $_[0] if $_[0];
    exit 0;
}

use Date::Parse;

usage "No start time submited" unless $s;
my $startim=str2time($s) or die;

my $endtim=str2time($e) if $e;
$endtim=time() unless $e;

usage "Logfile not submited" unless $ARGV[0];
open my $in, "<" . $ARGV[0] or usage "Can't open '$ARGV[0]' for reading";
$_=<$in>;
exit unless $_; # empty file
# Determining regular expression, depending on log format
my $logre=qr{^(\S{3}\s+\d{1,2}\s+(\d{2}:){2}\d+)};
$logre=qr{^[^\[]*\[(\d+/\S+/(\d+:){3}\d+\s\+\d+)\]} unless /$logre/;

while (<$in>) {
    /$logre/ && do {
        my $ltim=str2time($1);
        print if $endtim >= $ltim && $ltim >= $startim;
    };
};
