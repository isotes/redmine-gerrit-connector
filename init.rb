require_dependency 'gerrit_connector'

Redmine::Plugin.register :gerrit_connector do
	name 'Gerrit Connector'
	author 'Robert Sauter'
	description 'Add links to Gerrit for mirrored repositories'
	version '0.1.0'
	url 'https://github.com/isotes/redmine-gerrit-connector'
	author_url 'https://github.com/isotes'

	settings partial: 'settings/gerrit_connector_settings'
end
