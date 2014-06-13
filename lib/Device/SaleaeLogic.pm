package Device::SaleaeLogic;

use 5.010001;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Device::SaleaeLogic ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.02';

require XSLoader;
XSLoader::load('Device::SaleaeLogic', $VERSION);

# Preloaded methods go here.

sub new {
	my $self = shift;
	my $class = ref($self) || $self;
    my %args = @_;
    my $this = bless({%args}, $class);
    if ($args{verbose} or $args{debug}) {
        saleaeinterface_verbose();
    }
    my $obj = saleaeinterface_new($this);
    $this->{obj} = $obj;
    if (exists $args{on_connect} and ref $args{on_connect} eq 'CODE') {
        saleaeinterface_register_on_connect($obj, $args{on_connect});
    }
    if (exists $args{on_disconnect} and ref $args{on_disconnect} eq 'CODE') {
        saleaeinterface_register_on_disconnect($obj, $args{on_disconnect});
    }
    if (exists $args{on_readdata} and ref $args{on_readdata} eq 'CODE') {
        saleaeinterface_register_on_readdata($obj, $args{on_readdata});
    }
    if (exists $args{on_writedata} and ref $args{on_writedata} eq 'CODE') {
        saleaeinterface_register_on_writedata($obj, $args{on_writedata});
    }
    if (exists $args{on_error} and ref $args{on_error} eq 'CODE') {
        saleaeinterface_register_on_error($obj, $args{on_error});
    }
    if ($args{begin}) {
        saleaeinterface_begin_connect($obj);
    }
    return $this;
}

sub begin {
    saleaeinterface_begin_connect($_[0]->{obj});
}

sub DESTROY {
    saleaeinterface_DESTROY($_[0]->{obj}) if $_[0]->{obj};
}

sub is_usb2 {
    return saleaeinterface_is_usb2($_[0]->{obj}, $_[1]);
}

sub is_streaming {
    return saleaeinterface_is_streaming($_[0]->{obj}, $_[1]);
}

sub get_channel_count {
    return saleaeinterface_get_channel_count($_[0]->{obj}, $_[1]);
}

sub get_sample_rate {
    return saleaeinterface_get_sample_rate($_[0]->{obj}, $_[1]);
}

sub set_sample_rate {
    saleaeinterface_set_sample_rate($_[0]->{obj}, $_[1], $_[2]);
}

sub get_supported_sample_rates {
    return saleaeinterface_get_supported_sample_rates($_[0]->{obj}, $_[1]);
}

sub is_logic16 {
    return saleaeinterface_is_logic16($_[0]->{obj}, $_[1]);
}

sub is_logic {
    return saleaeinterface_is_logic($_[0]->{obj}, $_[1]);
}

sub get_device_id {
    return saleaeinterface_get_device_id($_[0]->{obj}, $_[1]);
}

sub read_start {
    saleaeinterface_read_start($_[0]->{obj}, $_[1]);
}

sub write_start {
    saleaeinterface_write_start($_[0]->{obj}, $_[1]);
}

sub stop {
    saleaeinterface_stop($_[0]->{obj}, $_[1]);
}

sub set_use5volts {
    saleaeinterface_set_use5volts($_[0]->{obj}, $_[1], $_[2] ? 1 : 0);
}

sub get_use5volts {
    return saleaeinterface_get_use5volts($_[0]->{obj}, $_[1]);
}

sub get_active_channels {
    return saleaeinterface_get_active_channels($_[0]->{obj}, $_[1]);
}

sub set_active_channels {
    return unless ref $_[2] eq 'ARRAY';
    saleaeinterface_set_active_channels($_[0]->{obj}, $_[1], $_[2]);
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

Device::SaleaeLogic - Perl extension for blah blah blah

=head1 VERSION

0.02

=head1 SYNOPSIS

  use strict;
  use warnings;
  use Device::SaleaeLogic;

  my $obj = Device::SaleaeLogic->new(
                on_connect => sub {
                    my ($self, $id) = @_;
                    #... do something here #
                },
                on_disconnect => sub {
                    my ($self, $id) = @_;
                    #... do something here #
                },
                on_readdata => sub {
                    my ($self, $id, $data, $len) = @_;
                    if ($len > 0) {
                        use bytes;
                        print "length: ", length($data), "\n";
                        print "length: $len\n";
                    }
                },
                on_error => sub {
                    my ($self, $id) = @_;
                },
                verbose => 1,
            );
  ##... have an event loop here or something ...

=head1 DESCRIPTION

=head2 EXPORT

None by default.

=head1 SEE ALSO

The github repository is at
L<https://github.com/vikasnkumar/p5-device-saleaelogic>. Feel free to provide us
patches.

Find me on IRC: I<#hardware> on L<irc://irc.perl.org> as user name B<vicash>.

=head1 AUTHOR

Vikas Kumar, E<lt>vikas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Vikas Kumar

This library is under the MIT license. Please refer the LICENSE file for more
information provided with the distribution.


=cut
