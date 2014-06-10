use Test::More;
BEGIN { use_ok('Device::SaleaeLogic') };

my $sl = new_ok('Device::SaleaeLogic');

can_ok($sl, 'DESTROY');
can_ok($sl, 'begin');
undef $sl;

done_testing();
