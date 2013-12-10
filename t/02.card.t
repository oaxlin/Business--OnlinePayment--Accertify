#!/usr/bin/perl -w
use strict;
use warnings;

use Test::More qw(no_plan);

## grab info from the ENV
my $login = $ENV{'BOP_USERNAME'} ? $ENV{'BOP_USERNAME'} : 'TESTMERCHANT';
my $password = $ENV{'BOP_PASSWORD'} ? $ENV{'BOP_PASSWORD'} : 'TESTPASS';
my $merchantid = $ENV{'BOP_MERCHANTID'} ? $ENV{'BOP_MERCHANTID'} : 'TESTMERCHANTID';
my $url = $ENV{'BOP_URL'} ? $ENV{'BOP_URL'} : 'https://127.0.0.1/test.xml';
my @opts = ('default_Origin' => 'RECURRING' );

## grab test info from the storable^H^H yeah actually just DATA now

my $authed =
    $ENV{BOP_USERNAME}
    && $ENV{BOP_PASSWORD}
    && $ENV{BOP_MERCHANTID};

use_ok 'Business::OnlinePayment';

SKIP: {
    skip "No Auth Supplied", 3 if ! $authed;
    ok( $login, 'Supplied a Login' );
    ok( $password, 'Supplied a Password' );
    like( $merchantid, qr/^\d+/, 'Supplied a MerchantID');
}

my %orig_content = (
    type           => 'CC',
    accertify_url  => $url,
    login          => $login,
    password       => $password,
    merchantid     =>  $merchantid,
    action         => 'Authorization Only', #'Normal Authorization',
    description    => 'BLU*BusinessOnlinePayment',
#    card_number    => '4007000000027',
    card_number     => '4457010000000009',
    cvv2            => '123',
    expiration      => '11/16',
    amount          => '49.95',
    currency        => 'UsD',
    order_number    => '1234123412341234',
    name            => 'Tofu Beast',
    email           => 'ippay@weasellips.com',
    address         => '123 Anystreet',
    city            => 'Anywhere',
    state           => 'UT',
    zip             => '84058',
    country         => 'US',      # will be forced to USA
    customer_id     => 'tfb',
    company_phone   => '801.123-4567',
    phone           => '123.123-1234',
    invoice_number  => '1234',
    ip              =>  '127.0.0.1',
    ship_name       =>  'Tofu Beast, Co.',
    ship_address    =>  '123 Anystreet',
    ship_city       => 'Anywhere',
    ship_state      => 'UT',
    ship_zip        => '84058',
    ship_country    => 'US',      # will be forced to USA
    tax             => 10,
    products        =>  [
    {   description =>  'First Product',
        quantity    =>  1,
        units       =>  'Months',
        amount      =>  500,
        discount    =>  0,
        code        =>  'sku1',
        cost        =>  500,
        tax         =>  0,
        totalwithtax => 500,
    },
    {   description =>  'Second Product',
        quantity    =>  1,
        units       =>  'Months',
        amount      =>  1500,
        discount    =>  0,
        code        =>  'sku2',
        cost        =>  500,
        tax         =>  0,
        totalwithtax => 1500,
    }

    ],
);

    my %auth_resp = ();
SKIP: {
    skip "No Test Account setup",54 if ! $authed;
    my %content = %orig_content;
### AUTH Tests
    print '-'x70;
    print "PARTIAL AUTH TESTS\n";

    my $tx = Business::OnlinePayment->new("Accertify", @opts);
    $tx->content(%content);
    my $ret = $tx->submit;
    is( $tx->is_success,    1,    "is_success: 1" );
    is( $tx->result_code,   '00',   "result_code(): 00" );
    like( $tx->order_number, qr/^\w{5,19}/, "order_number(): ".($tx->order_number||'') );
    #is( $tx->error_message, $o{error_message}, "error_message() / RESPMSG" );
    #is( $tx->avs_code,  $o{avs_code},  "avs_code() / AVSADDR and AVSZIP" );
    #is( $tx->cvv2_response, $o{cvv2_response}, "cvv2_response() / CVV2MATCH" );
}
