package TestApp::Action;
sub new { 
    my $class = shift;
    my $c = shift;
    bless { c => $c }, $class;
}

sub reverse {
    my$self = shift;
    my $path = $self->{c}->req->request_uri;
    $path =~ s/^\///;
    return $path;
}

1;
