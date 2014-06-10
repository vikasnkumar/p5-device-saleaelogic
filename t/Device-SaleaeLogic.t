use Test::More;
BEGIN { use_ok('Device::SaleaeLogic') };

my $sl = new_ok('Device::SaleaeLogic');

undef $sl;

done_testing();
