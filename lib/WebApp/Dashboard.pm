package WebApp::Dashboard;
use Mojo::Base 'Mojolicious::Controller';

use Fcntl qw(:flock SEEK_END LOCK_EX);

sub index {
  my $self = shift;

  my $hc = $self->hitcounter();
  $self->stash(counter => $hc);

  $self->render(
   title => 'Welcome',
   msg   => 'Mojolicious',
   icon  => '<i class="fa fa-cloud" aria-hidden="true"></i>',
   blurb => ' the real-time web framework' );
}

sub hitcounter {
  my $self = shift;
  my $file = '/home/vic/github/web_app/counter.txt';
  my $count = 0;
  if (open my $fh, '+<', $file) {
    flock($fh, LOCK_EX) or die "Cannot lock counter - $!\n";
    $count = <$fh>;
    $count++;
    seek $fh, 0, 0;
    truncate $fh, 0;
    print $fh $count;
    close $fh;
  }
  my $length  = 7 - length($count);
  my $pad = "0" x $length;
  my $cnt = $pad . $count;
  return $cnt;
}

1;
