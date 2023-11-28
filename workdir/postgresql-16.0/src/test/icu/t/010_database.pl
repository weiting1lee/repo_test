# Copyright (c) 2022-2023, PostgreSQL Global Development Group

use strict;
use warnings;
use PostgreSQL::Test::Cluster;
use PostgreSQL::Test::Utils;
use Test::More;

if ($ENV{with_icu} ne 'yes')
{
	plan skip_all => 'ICU not supported by this build';
}

my $node1 = PostgreSQL::Test::Cluster->new('node1');
$node1->init;
$node1->start;

$node1->safe_psql('postgres',
	q{CREATE DATABASE dbicu LOCALE_PROVIDER icu LOCALE 'C' ICU_LOCALE 'en@colCaseFirst=upper' ENCODING 'UTF8' TEMPLATE template0}
);

$node1->safe_psql(
	'dbicu',
	q{
CREATE COLLATION upperfirst (provider = icu, locale = 'en@colCaseFirst=upper');
CREATE TABLE icu (def text, en text COLLATE "en-x-icu", upfirst text COLLATE upperfirst);
INSERT INTO icu VALUES ('a', 'a', 'a'), ('b', 'b', 'b'), ('A', 'A', 'A'), ('B', 'B', 'B');
});

is( $node1->safe_psql('dbicu', q{SELECT def FROM icu ORDER BY def}),
	qq(A
a
B
b),
	'sort by database default locale');

is( $node1->safe_psql(
		'dbicu', q{SELECT def FROM icu ORDER BY def COLLATE "en-x-icu"}),
	qq(a
A
b
B),
	'sort by explicit collation standard');

is( $node1->safe_psql(
		'dbicu', q{SELECT def FROM icu ORDER BY en COLLATE upperfirst}),
	qq(A
a
B
b),
	'sort by explicit collation upper first');


# Test that LOCALE='C' works for ICU
is( $node1->psql(
		'postgres',
		q{CREATE DATABASE dbicu1 LOCALE_PROVIDER icu LOCALE 'C' TEMPLATE template0 ENCODING UTF8}
	),
	0,
	"C locale works for ICU");

# Test that LOCALE works for ICU locales if LC_COLLATE and LC_CTYPE
# are specified
is( $node1->psql(
		'postgres',
		q{CREATE DATABASE dbicu2 LOCALE_PROVIDER icu LOCALE '@colStrength=primary'
      LC_COLLATE='C' LC_CTYPE='C' TEMPLATE template0 ENCODING UTF8}
	),
	0,
	"LOCALE works for ICU locales if LC_COLLATE and LC_CTYPE are specified");

# Test that ICU-specific LOCALE without LC_COLLATE and LC_CTYPE must
# be specified with ICU_LOCALE
my ($ret, $stdout, $stderr) = $node1->psql(
	'postgres',
	q{CREATE DATABASE dbicu3 LOCALE_PROVIDER icu LOCALE '@colStrength=primary'
      TEMPLATE template0 ENCODING UTF8});
isnt($ret, 0,
	"ICU-specific locale must be specified with ICU_LOCALE: exit code not 0");
like(
	$stderr,
	qr/ERROR:  invalid LC_COLLATE locale name/,
	"ICU-specific locale must be specified with ICU_LOCALE: error message");


done_testing();
