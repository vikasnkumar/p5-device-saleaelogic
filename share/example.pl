#!/usr/bin/env perl

use strict;
use warnings;
use blib;
use Device::SaleaeLogic;

my $done = 0;

sub on_connect {
    my ($self, $id) = @_;
    print "Device with id: $id connected\n";
    $done = 0;
#    print "Device SDK ID: ", $self->get_device_id($id), "\n";
#    print "Device type: Logic16\n" if $self->is_logic16($id);
#    print "Device type: Logic\n" if $self->is_logic($id);
#    print "Device channel count: ", $self->get_channel_count($id), "\n";
#    print "Device sample rate: ", $self->get_sample_rate($id), " Hz\n";
#    my $arr = $self->get_supported_sample_rates($id);
#    print "Supported sample rates: ", join(", ", @$arr), " Hz\n";
#    print "USB 2.0 is supported\n" if $self->is_usb2($id);
}

sub on_disconnect {
    my ($self, $id) = @_;
    print "Device with id: $id disconnected\n";
    $done = 1;
}
sub on_error {
    my ($self, $id) = @_;
    print "Device with id: $id has error\n";
}
sub on_readdata {
    my ($self, $id, $data, $len) = @_;
    print "Device with id: $id reads data of length $len\n";
}
sub on_writedata {
    my ($self, $id, $data, $len) = @_;
    print "Device with id: $id writes data of length $len\n";
}

my $sl = Device::SaleaeLogic->new(
            on_connect => \&on_connect,
            on_disconnect => \&on_disconnect,
            on_error => \&on_error,
            on_readdata => \&on_readdata,
            on_writedata => \&on_writedata,
        );
$sl->begin;

until ($done) {
    sleep 5;
}
print "Done\n";
