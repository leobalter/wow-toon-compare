use Mojolicious::Lite;

get '/json' => sub {
	my $self  = shift;
	my $realm = $self->param('realm');
	my $name  = $self->param('name');
	my $wapi  = "http://us.battle.net/api/wow/character/$realm/$name";
	my $json  = $self->ua->get($wapi)->res->json;

	$self->render_json(
		$json);
};

get '/' => sub {
	my $self  = shift;
	my $vars;

	my $realm_1 = $self->param('first_realm');
	my $name_1  = $self->param('first_name');
	my $realm_2 = $self->param('second_realm');
	my $name_2 = $self->param('second_name');

	unless ($realm_1 and $name_1 and $realm_2 and $name_2) {
		return $self->render( 'form' );
	}

	$vars->{player_1} = data_from_API( $self, $realm_1, $name_1 );
	$vars->{player_2} = data_from_API( $self, $realm_2, $name_2 );

	return $self->render( 'compare', %$vars );
};

sub data_from_API {
	my ($self, $realm, $name) = @_;

  my $wapi = "http://us.battle.net/api/wow/character/$realm/$name";
	return $self->ua->get($wapi)->res->json;
}

app->start;
