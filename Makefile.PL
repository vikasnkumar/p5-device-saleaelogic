use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Device::SaleaeLogic',
    VERSION_FROM      => 'lib/Device/SaleaeLogic.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Device/SaleaeLogic.pm', # retrieve abstract from module
       AUTHOR         => 'Vikas Kumar <vikas@selectiveintellect.com>') : ()),
    LIBS              => ['-L. -lSaleaeDevice'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    OBJECT            => 'SaleaeLogic.o saleaeinterface.o', # link all the C files too
    ### we are doing this so that the header files needed are downloaded first
    #and the make file dependencies are managed appropriately
    PL_FILES          => { 'getSDK.PL' => '$(H_FILES)' }
);

__END__
