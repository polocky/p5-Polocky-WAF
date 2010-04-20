package Polocky::WAF::View;
use Polocky::Class;
use Polocky::Utils;
use UNIVERSAL::require;
extends qw(Polocky::Core);

has 'engine' => (
    is => 'rw',
    lazy_build => 1,
);
has 'except_engine' =>( is => 'rw' );

has default_type => (
    is => 'rw',
    default => 'TT',
);

has mime_type => (
    is => 'rw',
    default => 'text/html',
);

has charset => (
    is => 'rw',
    default => sub { Encode::find_encoding('utf-8') } ,
);

sub get_type {
    my $self = shift;
    my $c = shift;
    my $type = $c->stash->{template_type} ||  $self->default_type ;
    return $type;
}

sub get_mime_type {
    my $self = shift;
    my $type = shift;

    if( ref $self->mime_type eq 'HASH') {
        return $self->mime_type->{$type} ? $self->mime_type->{$type} : 'text/html' ;
    }
    else {
        return $self->mime_type ? $self->mime_type : 'text/html' ;
    }
}

sub get_mime_charset {
    my $self = shift;
    my $type = shift;

    if( ref $self->charset eq 'HASH') {
        return $self->charset->{$type} ? $self->charset->{$type}->mime_name : 'UTF-8';
    }
    else {
        return $self->charset ? $self->charset->mime_name : 'UTF-8';
    }
}
sub render {
    my $self = shift;
    my $c = shift;
    my $type = shift || $self->get_type($c);
    my $stash = shift;
    $self->_build_template( $c ,$type );
    $self->_build_stash( $c );
    my $output = $self->do_render( $c , $type , $stash );
    $self->_build_response( $c , $output );
    return 1;
}
sub do_render {
    my $self = shift;
    my $c    = shift;
    my $type = shift;
    my $stash = shift || $c->stash;
    $self->engine->render( $type, { vars => $stash ,file => $c->stash->{template} } );
}

sub _build_engine {
    my $self = shift;
    my $pkg = Polocky::Utils::app_class . '::View';
    $pkg->require or die $@;
    return $pkg->new( except_engine => $self->except_engine );
}
sub _build_stash {
    my ( $self, $c, $type ) = @_;
    $c->stash->{c} = $c;
    $c->stash->{config} = $c->config;
}

sub _build_template {
    my $self = shift;
    my $c = shift;
    my $type = shift;

    unless( $c->stash->{template} ) {
        $c->stash->{template} = $c->action->reverse .$self->engine->get_extention($type) if $c->can('action');
    }
}

sub _build_response {
    my ( $self, $c, $output ) = @_;
    $c->res->code(200) unless $c->res->code;
    $c->res->body($output);
    unless ( $c->res->content_type ) {
        my $type = $self->get_type($c);
        my $mime_type = $self->get_mime_type($type);
        my $mime_charset = $self->get_mime_charset($type);
        $c->res->content_type( "$mime_type; charset=$mime_charset" );
    }

    1;
}

__POLOCKY__;
