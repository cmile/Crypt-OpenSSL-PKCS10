# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Mytest.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { use_ok('Crypt::OpenSSL::PKCS10') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

{
my $req = Crypt::OpenSSL::PKCS10->new();
print STDERR $req->get_pem_req();
ok($req);
}

use_ok('Crypt::OpenSSL::RSA');

{
my $rsa = Crypt::OpenSSL::RSA->generate_key(1024);
my $req = Crypt::OpenSSL::PKCS10->new_from_rsa($rsa);
print STDERR $req->get_pem_req();
ok($req);
}

{
my $req = Crypt::OpenSSL::PKCS10->new();
$req->set_subject("/C=RO/O=UTI/OU=ssi");
$req->add_ext(Crypt::OpenSSL::PKCS10::NID_key_usage,"critical,digitalSignature,keyEncipherment");
$req->add_ext(Crypt::OpenSSL::PKCS10::NID_ext_key_usage,"serverAuth, nsSGC, msSGC, 1.3.4");
$req->add_ext(Crypt::OpenSSL::PKCS10::NID_subject_alt_name,'email:steve@openssl.org');
$req->add_custom_ext('1.2.3.3',"My new extension");
$req->add_ext_final();
$req->sign();
print STDERR $req->get_pem_req();
ok($req);
}