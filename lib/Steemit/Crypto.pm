package Steemit::Crypto;
use Modern::Perl;
use Math::EllipticCurve::Prime;
use Digest::SHA;
use Carp;

my $curve = Math::EllipticCurve::Prime->from_name('secp256k1');


sub point_from_x {
   my ( $x,$i ) = @_;
   my $y = recover_y( $x, $i );
   return Math::EllipticCurve::Prime::Point->new(
      x => $x,
      y => $y,
      curve => $curve
   );
}

sub recover_y {
   my ( $x,$i ) = @_;
   my $curve = Math::EllipticCurve::Prime->from_name('secp256k1');
   my ($p, $a, $b) = ($curve->p, $curve->a, $curve->b);
   $x = $x->copy;

   my $y = ($x->bmodpow(3,$p)+$a*$x+$b)->bmodpow(($p+1)/4,$p);

   $y = $p - $y if $i%2 ne $y%2;
   return $y;
}


sub get_public_key_point {
   my( $key ) = @_;

   die "key needs to be a Math::BigInt Object " unless( $key->isa('Math::BigInt') );

   my $public_key = $curve->g->multiply( $key );

   return $public_key;
}
1;
