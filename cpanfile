requires 'perl', '5.008005';
requires 'strict';
requires 'warnings';
requires 'Module::Pluggable::Object';

on 'test' => sub {
    requires 'File::Basename';
    requires 'YAML';
    requires 'Test::More', '1.3';
    requires 'Test::AllModules';
};

on 'configure' => sub {
    requires 'Module::Build' , '0.40';
    requires 'Module::Build::Pluggable';
    requires 'Module::Build::Pluggable::CPANfile';
};

on 'develop' => sub {
    requires 'Software::License';
    requires 'Test::Perl::Critic';
    requires 'Test::Pod::Coverage';
    requires 'Test::Pod';
    requires 'Test::NoTabs';
    requires 'Test::Vars';
    requires 'Test::File::Find::Rule';
};