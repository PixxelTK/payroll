module NavigationHelper
  def nav_link(name, path, icon: nil, match: nil)
    active =
      if match
        request.path.start_with?(match) || request.path == path
      else
        request.path == path || request.path.start_with?("#{path}/")
      end

    css = if active
      "flex items-center gap-2 px-3 py-2 rounded-lg bg-sky-500 text-white dark:bg-zinc-700 transition-all"
    else
      "flex items-center gap-2 px-3 py-2 rounded-lg hover:bg-zinc-200 text-slate-600 dark:text-slate-200 dark:hover:bg-zinc-800 transition-all"
    end

    link_to path,
      class: css,
      data: { turbo_frame: "content", turbo_action: "advance" } do
      concat heroicon(icon, variant: :outline, options: { class: "w-5 h-5" }) if icon
      concat content_tag(:span, name)
    end
  end
end
