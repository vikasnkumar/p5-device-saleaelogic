#!/usr/bin/env perl

use strict;
use warnings;
use blib;
use Data::Dumper;
use Device::SaleaeLogic;

my $done = 0;

my $g_id = 0;
sub on_connect {
    my ($self, $id) = @_;
    my $subname = 'on_connect';
    $done = 0;
    $g_id = $id;
    print "$subname: Device with id: $id connected\n";
    print "$subname: Device SDK ID: ", $self->get_device_id($id), "\n";
    print "$subname: Device type: Logic16\n" if $self->is_logic16($id);
    print "$subname: Device type: Logic\n" if $self->is_logic($id);
    print "$subname: Device channel count: ", $self->get_channel_count($id), "\n";
    print "$subname: Device sample rate: ", $self->get_sample_rate($id), " Hz\n";
    print "$subname: USB 2.0 is supported\n" if $self->is_usb2($id);
    my $arr = $self->get_supported_sample_rates($id);
    print "$subname: Supported sample rates: ", join(", ", @$arr), "\n";
}

sub on_disconnect {
    my ($self, $id) = @_;
    my $subname = 'on_disconnect';
    print "$subname: Device with id: $id disconnected\n";
    $done = 1;
}
sub on_error {
    my ($self, $id) = @_;
    my $subname = 'on_error';
    print "$subname: Device with id: $id has error\n";
}
sub on_readdata {
    my ($self, $id, $data, $len) = @_;
    my $subname = 'on_readdata';
    print "$subname: Device with id: $id reads data of length $len\n";
}
sub on_writedata {
    my ($self, $id, $data, $len) = @_;
    my $subname = 'on_writedata';
    print "$subname: Device with id: $id writes data of length $len\n";
}

my $sl = Device::SaleaeLogic->new(
            on_connect => \&on_connect,
            on_disconnect => \&on_disconnect,
            on_error => \&on_error,
            on_readdata => \&on_readdata,
            on_writedata => \&on_writedata,
            verbose => 1,
        );
$sl->begin;

my $once = 0;
until ($done) {
    sleep 5;
    if ($g_id > 0 and not $once) {
        my $subname = 'main';
        print "$subname: Device SDK ID: ", $sl->get_device_id($g_id), "\n";
        print "$subname: Device type: Logic16\n" if $sl->is_logic16($g_id);
        print "$subname: Device type: Logic\n" if $sl->is_logic($g_id);
        print "$subname: Device channel count: ", $sl->get_channel_count($g_id), "\n";
        print "$subname: Device sample rate: ", $sl->get_sample_rate($g_id), " Hz\n";
        print "$subname: USB 2.0 is supported\n" if $sl->is_usb2($g_id);
        my $arr = $sl->get_supported_sample_rates($g_id);
        print "$subname: Supported sample rates: ", join(", ", @$arr), "\n";
        $sl->set_sample_rate($g_id, $arr->[0]);
        sleep 1;
        print "$subname: Device sample rate is now: ", $sl->get_sample_rate($g_id), " Hz\n";
        $once++;
    }
}
print "Done\n";
