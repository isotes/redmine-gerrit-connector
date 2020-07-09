Deface::Override.new virtual_path: 'repositories/show',
		name: 'show-repositories-hook-other-formats-links',
		insert_after: 'erb[silent]:contains("other_formats_links")',
		text: '<%= call_hook(:view_repositories_show_other_formats_links, project: @project, repository: @repository, rev: @rev, path: @path, other_formats_links: f) %>'