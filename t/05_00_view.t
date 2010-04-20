use Test::Most qw/no_plan/;
use Test::Output;
use Polocky::Test::Initializer 'View';
use Polocky::WAF::View;
use TestApp::Context;
use Polocky::WAF::Request;
use Polocky::WAF::Response;
my $c = TestApp::Context->new();
$c->res( Polocky::WAF::Response->new );
$c->req( Polocky::WAF::Request->new(
+{
    REQUEST_METHOD    => 'GET',
    SERVER_PROTOCOL   => 'HTTP/1.1',
    SERVER_PORT       => 80,
    SERVER_NAME       => 'example.com',
    SCRIPT_NAME       => '/foo',
    REMOTE_ADDR       => '127.0.0.1',
    REQUEST_URI       => '/view/a/tt',
    'psgi.version'    => [ 1, 0 ],
    'psgi.input'      => undef,
    'psgi.errors'     => undef,
    'psgi.url_scheme' => 'http',
}
) );


my $view = Polocky::WAF::View->new();

# default template , set content type 
    is($c->res->content_type,'');
    $view->render($c,'Site',{name => 'polocky'}); 
    my @content_type = $c->res->content_type;
    is($content_type[0],'text/html');
    is($content_type[1],'charset=UTF-8');
    is($c->stash->{template},'view/a/tt.tt' , 'default templ with action mock' );
    is($c->res->body,"TT polocky\n");


