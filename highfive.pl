#!/usr/bin/perl

use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '0.1';
%IRSSI = (
    authors     => 'Trevor Joynson',
    contact     => 'trevorj@skywww.net',
    name        => 'highfive',
    description => 'High Five Peoples!',
    license     => 'Public Domain',
);

my @highfive = (
	'               _.-._',
	'              | | | |_',
	'              | | | | |',
	'              | | | | |',
	'            _ |  \'-._ |',
	'            \\`\\`-.\'-._;',
	'             \\    \'   |',
	'              \\  .`  /',
	'        jgs    |    |',
	);

sub highfive {
	my ($msg, $server, $nick, $address, $channel) = @_;

	if ($server || $server->{connected}) {
		foreach (@highfive) {
			Irssi::active_win()->command(Irssi::settings_get_str('cmdchars') . " " . $_);
		}
	}
}

Irssi::command_bind ('highfive', \&highfive);

