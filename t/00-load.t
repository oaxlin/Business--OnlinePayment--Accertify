#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Business::OnlinePayment::Accertify' );
}

diag( "Testing Business::OnlinePayment::Accertify $Business::OnlinePayment::Accertify::VERSION, Perl $], $^X" );
