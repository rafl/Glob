package Glob::Unpacker;

use Moose;
use syntax 'method';
use JSON;
use Cond::Expr;
use ZeroMQ ':all';
use Data::Dump 'pp';
use Glob::Types ':all';
use namespace::autoclean;

has ipc_path => (
    is => 'ro',
    isa => IPCPath,
    required => 1,
    documentation => 'This is the IPC URL required for ZeroMQ',
);

has gitter => (
    is => 'ro',
    isa => 'Glob::Git',
    required => 1,
    handles => [qw/
        gitify
    /],
);

has consumer => (
    isa      => Consumer,
    required => 1,
    handles  => {
        consume_payload => 'consume',
    },
);

method run {
    my $ctx = ZeroMQ::Context->new;
    my $pullsock = $ctx->socket(ZMQ_PULL);
    $pullsock->connect($self->ipc_path);
    $pullsock->setsockopt(ZMQ_HWM, 4);

    while (1) {
        my $payload = $self->consume_payload;

        cond
            ($payload->{action} eq 'store_dist') { $self->gitify($payload->{dist}) }
            otherwise { die "unknown action in " . pp $payload };
    }
}

__PACKAGE__->meta->make_immutable;

1;
