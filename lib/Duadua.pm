package Duadua;
use strict;
use warnings;
use Duadua::Parser;

our $VERSION = '0.01';

my @PARSER_PROC_LIST = qw/
    Duadua::Parser::Browser::MicrosoftEdge
    Duadua::Parser::Browser::GoogleChrome
    Duadua::Parser::Browser::MicrosoftInternetExplorer

    Duadua::Parser::Bot::Googlebot
    Duadua::Parser::Bot::GooglebotMobile
    Duadua::Parser::Bot::GooglebotAd
    Duadua::Parser::Bot::GoogleRead
    Duadua::Parser::Bot::Bingbot
    Duadua::Parser::Bot::AdIdxBot
    Duadua::Parser::Bot::BingPreview

    Duadua::Parser::Browser::Opera
    Duadua::Parser::Browser::MozillaFirefox

    Duadua::Parser::Browser::AppleSafari

    Duadua::Parser::HTTPClient::HTTPClient

    Duadua::Parser::Bot::Twitterbot
    Duadua::Parser::Bot::FacebookCrawler
    Duadua::Parser::Bot::Slackbot

    Duadua::Parser::Bot::YahooSlurp
    Duadua::Parser::Bot::Baiduspider
    Duadua::Parser::Bot::YandexBot
    Duadua::Parser::Bot::GooglebotMisc
    Duadua::Parser::Bot::DuckDuckBot
    Duadua::Parser::Bot::Msnbot
    Duadua::Parser::Bot::BotMisc

    Duadua::Parser::Browser::Yandex
    Duadua::Parser::Browser::DuckDuckGo
    Duadua::Parser::Browser::BrowserMisc

    Duadua::Parser::Bot::YahooJapanBot
    Duadua::Parser::Bot::HatenaBot
    Duadua::Parser::FeaturePhone::FeaturePhone
/;

sub new {
    my $class = shift;
    my $ua    = shift // $ENV{'HTTP_USER_AGENT'} // '';
    my $opt   = shift || {};

    my @parsers;
    if (exists $opt->{skip}) {
        for my $p (@PARSER_PROC_LIST) {
            next if grep { $p eq $_ } @{$opt->{skip}};
            push @parsers, $p;
        }
    }
    else {
        @parsers = @PARSER_PROC_LIST;
    }

    bless {
        _ua          => $ua,
        _parsed      => 0,
        _result      => {},
        _parsers     => \@parsers,
        _opt_version => $opt->{version},
    }, $class;
}

sub opt_version { shift->{_opt_version} }

sub parsers { shift->{_parsers} }

sub ua { shift->{_ua} }

sub reparse {
    my ($self, $ua) = @_;

    $self->{_ua}     = $ua // $ENV{'HTTP_USER_AGENT'} // '';
    $self->{_result} = {};

    return $self->parse;
}

sub _result {
    my ($self, $value) = @_;

    if ($value) {
        $self->{_result} = $value;
        return $self;
    }
    else {
        $self->parse unless $self->{_parsed};
        return $self->{_result};
    }
}

sub parse {
    my $self = shift;

    if (ref $self eq __PACKAGE__) {
        $self->_parse;
    }
    elsif ($self eq __PACKAGE__ && scalar @_ == 1) {
        # my $d_obj = Duadua->parse('User-Agent String');
        my $d = __PACKAGE__->new($_[0]);
        return $d->_parse;
    }
    else {
        # my $d_obj = Duadua::parse('User-Agent String');
        my $d = __PACKAGE__->new($self);
        return $d->_parse;
    }
}

sub _parse {
    my $self = shift;

    $self->_result(Duadua::Parser->parse($self));
    $self->{_parsed} = 1;

    return $self;
}

sub name {
    shift->_result->{name};
}

sub is_bot {
    shift->_result->{is_bot} ? 1 : 0;
}

sub is_ios {
    shift->_result->{is_ios} ? 1 : 0;
}

sub is_android {
    shift->_result->{is_android} ? 1 : 0;
}

sub is_linux {
    shift->_result->{is_linux} ? 1 : 0;
}

sub is_windows {
    shift->_result->{is_windows} ? 1 : 0;
}

sub version {
    shift->_result->{version} || '';
}

1;

__END__

=encoding UTF-8

=head1 NAME

Duadua - Detect User-Agent


=head1 SYNOPSIS

    use Duadua;

    my $ua = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)';

    my $d = Duadua->new($ua);
    $d->is_bot
        and say $d->name; # Googlebot

Or call as a function to parse immediately

    my $d = Duadua->parse($ua);
    $d->is_bot
        and say $d->name; # Googlebot


=head1 DESCRIPTION

Duadua is a User-Agent detector.


=head1 METHODS

=head2 new($user_agent_string, $options_hash)

constructor

=head3 Constructor options

=over

=item version => 1 or 0

If you set the true value to C<version>, then you can get version string. (By default, don't get version)

=item skip => ['ParserClass']

If you set the array to C<skip>, then you can skip detect logic by specific classes.

NOTE that ParserClass is case sensitive, and it might be going to change results.

=back

=head2 name

Get User-Agent name

=head2 is_bot

Return true value if the User-Agent is bot.

=head2 is_ios

Return true value if the User-Agent is iOS.

=head2 is_android

Return true value if the User-Agent is Android.

=head2 is_linux

Return true value if the User-Agent is Linux.

=head2 is_windows

Return true value if the User-Agent is Windows.

=head2 version

Return version string

=head2 parse

Parse User-Agent string

=head2 reparse($ua)

Parse User-Agent string by same instance without new

=head2 ua

Return User-Agent string

=head2 opt_version

The shortcut of C<opt('version')>

=head2 parsers

The list of User Agent Parser


=head1 REPOSITORY

=begin html

<a href="https://github.com/bayashi/Duadua/blob/master/LICENSE"><img src="https://img.shields.io/badge/LICENSE-Artistic%202.0-GREEN.png"></a> <a href="https://github.com/bayashi/Duadua/actions"><img src="https://github.com/bayashi/Duadua/workflows/build/badge.svg?_t=1577048828&branch=master"/></a> <a href="https://coveralls.io/r/bayashi/Duadua"><img src="https://coveralls.io/repos/bayashi/Duadua/badge.png?_t=1577048828&branch=master"/></a>

=end html

Duadua is hosted on github: L<http://github.com/bayashi/Duadua>

I appreciate any feedback :D


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 LICENSE

C<Duadua> is free software; you can redistribute it and/or modify it under the terms of the Artistic License 2.0. (Note that, unlike the Artistic License 1.0, version 2.0 is GPL compatible by itself, hence there is no benefit to having an Artistic 2.0 / GPL disjunction.) See the file LICENSE for details.

=cut
