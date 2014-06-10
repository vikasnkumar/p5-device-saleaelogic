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

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Device::SaleaeLogic', $VERSION);

# Preloaded methods go here.

sub new {
	my $self = shift;
	my $class = ref($self) || $self;
    my %args = @_;
    my $this = bless({%args}, $class);
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
    saleaeinterface_DESTROY($_[0]->{obj});
}

sub is_usb2 {
    return saleaeinterface_is_usb2($_[0]->{obj});
}

sub is_streaming {
    return saleaeinterface_is_streaming($_[0]->{obj});
}

sub get_channel_count {
    return saleaeinterface_get_channel_count($_[0]->{obj});
}

sub get_sample_rate {
    return saleaeinterface_get_sample_rate($_[0]->{obj});
}

sub set_sample_rate {
    saleaeinterface_set_sample_rate($_[0]->{obj}, $_[1]);
}

sub get_supported_sample_rates {
    return saleaeinterface_get_supported_sample_rates($_[0]->{obj});
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Device::SaleaeLogic - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Device::SaleaeLogic;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Device::SaleaeLogic, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Vikas Kumar, E<lt>vikas@selectiveintellect.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Vikas Kumar

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
