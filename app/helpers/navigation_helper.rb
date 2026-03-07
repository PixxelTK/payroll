module NavigationHelper
  def nav_link(name, path)
    active =
      if path == root_path
        request.path == root_path
      else
        request.path.start_with?(path)
      end

    css = if active
      "block px-3 py-2 rounded-lg bg-sky-500 text-white dark:bg-zinc-700 transition-all"
    else
      "block px-3 py-2 rounded-lg hover:bg-zinc-200 text-slate-600 dark:text-slate-200 dark:hover:bg-zinc-800 transition-all"
    end

    link_to name, path,
      class: css,
      data: { turbo_frame: "content", turbo_action: "advance" }
  end
end
