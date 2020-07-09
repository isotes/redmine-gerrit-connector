module GerritConnector
	class GerritConnectorHookListener < Redmine::Hook::ViewListener
		def check_settings
			@local_git_base_url = Settings.get(:local_git_base_url)
			@gerrit_base_url = Settings.get(:gerrit_base_url)
			@gitiles_base_url = Settings.get(:gitiles_base_url)
			return false if @local_git_base_url.blank? || @gerrit_base_url.blank?

			@gitiles_base_url = @gerrit_base_url + 'plugins/gitiles/' if @gitiles_base_url.blank?
			true
		end

		def button(key, url, same_window = false)
			key += '_'
			return '' unless Settings.get(key + 'show')

			content_tag('span', link_to(
					I18n.t(key + 'name'),
					url,
					class: Settings.get(key + 'css_class'),
					title: I18n.t(key + 'title'),
					target: same_window ? '' : '_blank'
				))
		end

		def view_repositories_show_other_formats_links(context = {})
			return unless check_settings

			repo = context[:repository].url
			rev = context[:rev]
			path = context[:path]

			return unless repo.start_with?(@local_git_base_url)

			repo = repo[@local_git_base_url.size..(repo.end_with?('.git') ? -5 : -1)]

			ref = "refs/heads/#{rev}"
			ref += '/' +path unless path.empty?

			button('revision_gerrit', "#{@gerrit_base_url}q/project:#{repo}") +
				button('revision_gitiles', "#{@gitiles_base_url}#{repo}/+/#{ref}") +
				button('revision_download', "#{@gitiles_base_url}#{repo}/+archive/#{ref}.tar.gz", true)
		end

		def view_issues_show_other_formats_links(context = {})
			return unless check_settings

			button('issue_gerrit', "#{@gerrit_base_url}q/tr:#{context[:issue].id}")
		end
	end
end
