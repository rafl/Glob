package Glob::Consumer::ZeroMQ;

use Moose;
use JSON;
use syntax 'method';
use namespace::autoclean;

has socket => (
    isa      => 'ZeroMQ::Socket',
    required => 1,
    handles  => ['recv'],
);

method consume  {
    return decode_json $self->recv->data;
}

with 'Glob::Consumer';

__PACKAGE__->meta->make_immutable;

1;
