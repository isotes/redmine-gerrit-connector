Deface::Override.new virtual_path: 'issues/show',
		name: 'show-issues-hook-other-formats-links',
		insert_after: 'erb[silent]:contains("other_formats_links")',
		text: '<%= call_hook(:view_issues_show_other_formats_links, project: @project, issue: @issue, other_formats_links: f) %>'
