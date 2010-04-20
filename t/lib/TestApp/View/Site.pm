package TestApp::View::Site;
use Polocky::Class;
extends qw(Polocky::View::TT);
has pre_process => ( is => 'rw', default => '' );
sub _build_root {
    't/testhome/view/view';
}
__POLOCKY__;
