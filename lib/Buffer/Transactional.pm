package Buffer::Transactional;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::AttributeHelpers;

use Buffer::Transactional::StringBuffer;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'out' => (
    is       => 'ro',
    isa      => duck_type( [ 'print' ] ),
    required => 1,
);

has '_buffers' => (
    metaclass => 'Collection::Array',
    is        => 'ro',
    isa       => 'ArrayRef[ Buffer::Transactional::Buffer ]',
    lazy      => 1,
    default   => sub { [] },
    provides  => {
        'pop'   => 'clear_current_buffer',
        'empty' => 'has_current_buffer',
        'push'  => '_add_buffer',
    },
    curries   => {
        'get'  => { 'current_buffer' => [ -1 ] },
    }
);

has 'buffer_class' => (
    is      => 'ro',
    isa     => 'ClassName',
    lazy    => 1,
    default => sub { 'Buffer::Transactional::StringBuffer' },
);

sub begin_work {
    my $self = shift;
    $self->_add_buffer( $self->buffer_class->new );
}

sub commit {
    my $self = shift;
    ($self->has_current_buffer)
        || confess "Not within transaction scope";

    my $current = $self->clear_current_buffer;

    if ($self->has_current_buffer) {
        $self->current_buffer->subsume( $current );
    }
    else {
        $self->out->print( $current->as_string );
    }
}

sub rollback {
    my $self = shift;
    ($self->has_current_buffer)
        || confess "Not within transaction scope";
    $self->clear_current_buffer;
}

sub _write_to_buffer {
    my $self = shift;
    ($self->has_current_buffer)
        || confess "Not within transaction scope";
    $self->current_buffer->put( @_ );
}

sub print {
    my ($self, @data) = @_;
    $self->_write_to_buffer( @data );
}

sub printf {
    my ($self, $format, @data) = @_;
    $self->_write_to_buffer( sprintf $format, @data );
}

sub say {
    my ($self, @data) = @_;
    $self->_write_to_buffer( map { "$_\n" } @data );
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Buffer::Transactional - A Moosey solution to this problem

=head1 SYNOPSIS

  use Try::Tiny;
  use Buffer::Transactional;

  my $b = Buffer::Transactional->new( out => IO::File->new(">", "foo.txt") );
  try {
      $b->print('OH HAI');
      $b->print('KTHNXBYE');
      die "Whoops!\n"
  } catch {
      $b->rollback;
  };

  $b->commit;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
