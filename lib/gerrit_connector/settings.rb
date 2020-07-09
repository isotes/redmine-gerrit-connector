module GerritConnector
	# Helper functions for settings because when using the normal form functions, all settings are strings
	module Settings
		# Settings ending with _url are normalized to end with a slash (unless blank)
		# Settings ending with _css_class are stripped of everything but letters, numbers, space, minus, and underscore
		DEFAULT = {
			local_git_base_url: '',
			gerrit_base_url: '',
			gitiles_base_url: '',
		}.freeze
		# handled as bool: true if == '1'
		DEFAULT_BOOLS = {
			revision_gerrit_show: '1',
			revision_gitiles_show: '1',
			revision_download_show: '1',
			issue_gerrit_show: '1',
		}.freeze
		# shown empty in the settings dialog but uses fallback in code
		DEFAULT_FALLBACKS = {
			revision_gerrit_css_class: 'icon icon-magnifier',
			revision_gitiles_css_class: 'icon icon-folder',
			revision_download_css_class: 'icon icon-download',
			issue_gerrit_css_class: 'icon icon-magnifier',
		}.freeze

		PURE_DEFAULTS = DEFAULT.merge(DEFAULT_BOOLS).merge(DEFAULT_FALLBACKS.map{ |k, _v| [k, ''] }.to_h).freeze

		def self.fallback(key)
			DEFAULT_FALLBACKS[key.to_sym]
		end

		# return setting without fallback, but with sanitized CSS class
		def self.pure(key)
			key = key.to_sym
			begin
				v = Setting.plugin_gerrit_connector[key] || PURE_DEFAULTS[key]
			rescue StandardError
				v = PURE_DEFAULTS[key]
			end
			if DEFAULT_BOOLS.key?(key)
				v == '1'
			elsif key.to_s.end_with?('_css_class')
				v.to_s.tr('^ \-_A-Za-z0-9', '')
			else
				v
			end
		end

		# return setting with fallback and normalize URLs to end with a slash
		def self.get(key)
			v = pure(key)
			fallback = DEFAULT_FALLBACKS[key.to_sym]
			v += '/' if key.to_s.end_with?('_url') && !(v.to_s.blank? || v.to_s.end_with?('/'))
			fallback && v.blank? ? fallback : v
		end

	end
end
