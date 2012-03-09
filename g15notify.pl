#!/usr/bin/perl -w
##
## g15notify.pl -- Quick hack to simply send hilights to g15message
## - Trevor Joynson
## - 06/30/09
##
## Based upon notify.pl by Luke Macken and Paul W. Frields
##

#TODO
# - Extend this to have activity per-channel as well
# - Make it look prettier, maybe even a menu-like interface for showing windows

##
## Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /load perl
##       /script load notify
##

use strict;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = "0.01";
%IRSSI = (
    authors     => 'Trevor Joynson',
    contact     => 'g15notify@skywww.net',
    name        => 'g15notify.pl',
    description => 'Use g15message to alert user to hilights',
    license     => 'GNU General Public License',
    url         => 'http://wiki.skywww.net/g15notify',
);

Irssi::settings_add_str('g15notify', 'g15message_opts', '-d 5 -s 5');

sub g15notify {
    my ($server, $summary, $message) = @_;

	$message =~ s/[^A-Za-z0-9]//g;
	$summary =~ s/[^A-Za-z0-9]//g;

    my $cmd = "EXEC - g15message " . Irssi::settings_get_str('g15message_opts') . " -t $summary $message";

    $server->command($cmd);
#    Irssi::print($cmd);
}
 
sub print_text_notify {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};

    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    my $sender = $stripped;
    $sender =~ s/^\<.([^\>]+)\>.+/\1/ ;
    $stripped =~ s/^\<.[^\>]+\>.// ;
    my $summary = $dest->{target} . ": " . $sender;

    g15notify($server, $summary, $stripped);
}

sub message_private_notify {
    my ($server, $msg, $nick, $address) = @_;

    return if (!$server);
    g15notify($server, "Private message from ".$nick, $msg);
}

sub dcc_request_notify {
    my ($dcc, $sendaddr) = @_;
    my $server = $dcc->{server};

    return if (!$dcc);
    g15notify($server, "DCC ".$dcc->{type}." request", $dcc->{nick});
}

Irssi::signal_add('print text', 'print_text_notify');
Irssi::signal_add('message private', 'message_private_notify');
Irssi::signal_add('dcc request', 'dcc_request_notify');

